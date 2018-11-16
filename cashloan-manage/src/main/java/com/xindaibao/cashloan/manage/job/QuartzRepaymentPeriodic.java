package com.xindaibao.cashloan.manage.job;

import com.xindaibao.cashloan.cl.domain.BankCard;
import com.xindaibao.cashloan.cl.domain.BorrowRepay;
import com.xindaibao.cashloan.cl.domain.PayLog;
import com.xindaibao.cashloan.cl.model.BorrowRepayLogModel;
import com.xindaibao.cashloan.cl.model.BorrowRepayModel;
import com.xindaibao.cashloan.cl.model.PayLogModel;
import com.xindaibao.cashloan.cl.model.pay.lianlian.QueryRepaymentModel;
import com.xindaibao.cashloan.cl.model.pay.lianlian.RepaymentModel;
import com.xindaibao.cashloan.cl.model.pay.lianlian.constant.LianLianConstant;
import com.xindaibao.cashloan.cl.model.pay.lianlian.util.LianLianHelper;
import com.xindaibao.cashloan.cl.service.*;
import com.xindaibao.cashloan.core.common.context.Global;
import com.xindaibao.cashloan.core.common.exception.ServiceException;
import com.xindaibao.cashloan.core.common.util.DateUtil;
import com.xindaibao.cashloan.core.domain.Borrow;
import com.xindaibao.cashloan.core.domain.User;
import com.xindaibao.cashloan.core.domain.UserBaseInfo;
import com.xindaibao.cashloan.core.model.KanyaUser;
import com.xindaibao.cashloan.core.service.CloanUserService;
import com.xindaibao.cashloan.core.service.UserBaseInfoService;
import com.xindaibao.cashloan.manage.domain.QuartzInfo;
import com.xindaibao.cashloan.manage.domain.QuartzLog;
import com.xindaibao.cashloan.manage.service.QuartzInfoService;
import com.xindaibao.cashloan.manage.service.QuartzLogService;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;
import tool.util.BeanUtil;
import tool.util.BigDecimalUtil;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 周期性-代扣还款任务
 */
@Component
@Lazy(value = false)
public class QuartzRepaymentPeriodic implements Job {

	private static final Logger logger = Logger.getLogger(QuartzRepaymentPeriodic.class);
	private  final int WITHHOLD_PERIODIC_DAYS = 7;
	private  final int WITHHOLD_PERIODIC_COUNT = 12;
	private  final int WITHHOLD_CONTINUOUS_DAYS = 3;


	private String repayment() throws ServiceException {
		logger.info("进入-周期性-代扣还款任务...");
		CloanUserService cloanUserService = (CloanUserService) BeanUtil.getBean("cloanUserService");
		UserBaseInfoService userBaseInfoService = (UserBaseInfoService) BeanUtil.getBean("userBaseInfoService");
		BankCardService bankCardService = (BankCardService) BeanUtil.getBean("bankCardService");
		ClBorrowService clBorrowService = (ClBorrowService) BeanUtil.getBean("clBorrowService");
		BorrowRepayService borrowRepayService = (BorrowRepayService) BeanUtil.getBean("borrowRepayService");
		PayLogService payLogService = (PayLogService) BeanUtil.getBean("payLogService");
		ClSmsService clSmsService = (ClSmsService) BeanUtil.getBean("clSmsService");

		//代扣间隔天数
		int withholdPeriodicDays = Global.getInt("withhold_periodic_days")  == 0
				? WITHHOLD_PERIODIC_DAYS
				: Global.getInt("withhold_periodic_days");
		//代扣间隔次数
		int withholdPeriodicCount = Global.getInt("withhold_periodic_count")  == 0
				? WITHHOLD_PERIODIC_COUNT
				: Global.getInt("withhold_periodic_count");
		//代扣连续几天
		int withholdContinuousDays = Global.getInt("withhold_continuous_days")  == 0
				? WITHHOLD_CONTINUOUS_DAYS
				: Global.getInt("withhold_continuous_days");

		// 查询待还计划
		Map<String, Object> paramMap = new HashMap<String, Object>(); // 是否代扣今天待还的
		paramMap.put("repayTime", DateUtil.getNow());
		paramMap.put("state", BorrowRepayModel.STATE_REPAY_NO);
		List<BorrowRepay> borrowRepayList = borrowRepayService.findUnRepay(paramMap);

		logger.info("周期性还款任务，待处理的还款计划总数为：" + borrowRepayList.size());

		String quartzRemark = null;
		int succeed = 0;
		int fail = 0;
		int total = 0;
		for (BorrowRepay borrowRepay : borrowRepayList) {

			long day = tool.util.DateUtil.daysBetween(borrowRepay.getRepayTime(), DateUtil.getNow());
			logger.info("周期性还款任务，borrowReapyId：" + borrowRepay.getId() + "逾期"+day+"天");
			/*所有未还款的都代扣*/
			/*if(day <= withholdContinuousDays){
				logger.info("周期性还款任务，borrowReapyId：" + borrowRepay.getId() + "逾期"+withholdContinuousDays+"天内--:"+day);
			} else if(day % withholdPeriodicDays == 1 && day / withholdPeriodicDays <= withholdPeriodicCount){
				logger.info("周期性还款任务，borrowReapyId：" + borrowRepay.getId() + "每隔"+withholdPeriodicDays+"天代扣:"+day);
			} else {
				logger.info("周期性还款任务，borrowReapyId：" + borrowRepay.getId() + "不在代扣时间"+day);
				continue;
			}*/

			logger.info("周期性还款任务，borrowReapyId：" + borrowRepay.getId() + "开始处理");
			try {
				// 查询用户、用户详情、借款及用户银行卡信息
				KanyaUser user = cloanUserService.getById(borrowRepay.getUserId());
				UserBaseInfo baseInfo = userBaseInfoService.findByUserId(borrowRepay.getUserId());
				Borrow borrow = clBorrowService.getById(borrowRepay.getBorrowId());
				BankCard bankCard = bankCardService.getBankCardByUserId(borrowRepay.getUserId());



				// 扣款失败无异步通知 故先查询订单是否已经在支付处理中
				Map<String, Object> payLogMap = new HashMap<String, Object>();
				payLogMap.put("userId", borrowRepay.getUserId());
				payLogMap.put("borrowId", borrowRepay.getBorrowId());
				payLogMap.put("type", PayLogModel.TYPE_COLLECT);
				payLogMap.put("scenes", PayLogModel.SCENES_REPAYMENT);
				PayLog repaymentLog = payLogService.findLatestOne(payLogMap);
				// FIXME: 2017/11/22 不改变查询代码前提下，无手动扣款记录，再查询自动还款记录
				if(null == repaymentLog ){
					payLogMap.put("type", PayLogModel.TYPE_ACTIVE_DEBIT_LIANLIAN);
					payLogMap.put("scenes", PayLogModel.SCENES_ACTIVE_REPAYMENT);
					repaymentLog = payLogService.findLatestOne(payLogMap);
				}

				// 支付记录存在且不是支付失败，需要查询支付方得到准确结果
				if (null != repaymentLog && !PayLogModel.STATE_PAYMENT_FAILED.equals(repaymentLog.getState())) {
					if (PayLogModel.STATE_PAYMENT_SUCCESS.equals(repaymentLog.getState())) {
						logger.info("周期性-borrowReapyId：" + borrowRepay.getId() + "-finish" + PayLogModel.STATE_PAYMENT_SUCCESS );
						continue;
					}

					Map<String, Object> queryRepaymentMap = new HashMap<>();
					queryRepaymentMap.put("queryOrderNo", repaymentLog.getOrderNo());
					queryRepaymentMap.put("queryOrderTime", repaymentLog.getPayReqTime());
					QueryRepaymentModel queryRepayment = (QueryRepaymentModel) LianLianHelper.queryRepayment(queryRepaymentMap);

					if (queryRepayment.checkReturn() && LianLianConstant.RESULT_SUCCESS.equals(queryRepayment.getResult_pay())) {
						logger.info("周期性-borrowReapyId：" + borrowRepay.getId() + "-lianlian said success, " );
						// 查找对应的还款计划
						Map<String, Object> param = new HashMap<String, Object>();
						param.put("id", borrowRepay.getId());
						param.put("repayTime", DateUtil.getNow());
						param.put("repayWay",BorrowRepayLogModel.REPAY_WAY_CHARGE);
						param.put("repayAccount", bankCard.getCardNo());
						param.put("amount", borrowRepay.getAmount());
						param.put("serialNumber", repaymentLog.getOrderNo());
						param.put("penaltyAmout",borrowRepay.getPenaltyAmout());
						param.put("state", "10");
						if (!borrowRepay.getState().equals(BorrowRepayModel.STATE_REPAY_YES)) {
							borrowRepayService.confirmRepay(param);
						}

						// 更新订单状态
						Map<String, Object> payLogParamMap = new HashMap<String, Object>();
						payLogParamMap.put("state",PayLogModel.STATE_PAYMENT_SUCCESS);
						payLogParamMap.put("updateTime", DateUtil.getNow());
						payLogParamMap.put("id", repaymentLog.getId());
						payLogService.updateSelective(payLogParamMap);

						//发送扣款成功短信
						if(tool.util.DateUtil.daysBetween(tool.util.DateUtil.getNow(), borrowRepay.getRepayTime())>=0){
							//未逾期还款成功
							clSmsService.repayInform(borrowRepay.getUserId(), borrowRepay.getBorrowId(),"noRepayInform");
						}else{
							clSmsService.repayInform(borrowRepay.getUserId(), borrowRepay.getBorrowId(),"repayInformSucess");
						}
						continue;
					} else if (queryRepayment.checkReturn() && LianLianConstant.RESULT_PROCESSING.equals(queryRepayment.getResult_pay())) {
						logger.info("周期性-borrowReapyId：" + borrowRepay.getId() + "-lianlian said processing, " );
						continue;
					} else {
						// 更新订单状态
						logger.info("周期性-borrowReapyId：" + borrowRepay.getId() + "-lianlian said failed, " );
						Map<String, Object> payLogParamMap = new HashMap<String, Object>();
						payLogParamMap.put("state",PayLogModel.STATE_PAYMENT_FAILED);
						payLogParamMap.put("updateTime", DateUtil.getNow());
						payLogParamMap.put("id", repaymentLog.getId());
						payLogService.updateSelective(payLogParamMap);
					}
				}

				// 计算实际还款金额
				//double principal = BigDecimalUtil.sub(borrowRepay.getAmount(), borrowRepay.getReliefAmount());
				//double penaltyAmout = BigDecimalUtil.sub(borrowRepay.getPenaltyAmout(), borrowRepay.getReliefFine());
				double principal = BigDecimalUtil.sub(borrowRepay.getAmount(), 0);
				double penaltyAmout = BigDecimalUtil.sub(borrowRepay.getPenaltyAmout(), 0);
				double amount = BigDecimalUtil.add(principal ,penaltyAmout);

				Date payReqTime = DateUtil.getNow();
				Map<String, Object> repaymentMap = new HashMap<>();
				repaymentMap.put("user", user);
				repaymentMap.put("userBaseInfo", baseInfo);
				repaymentMap.put("agreeNo", bankCard.getAgreeNo());
				repaymentMap.put("payTime", payReqTime);
				repaymentMap.put("amount", amount);
				repaymentMap.put("repayTime", borrowRepay.getRepayTime());
				repaymentMap.put("borrowOrderNo", borrow.getOrderNo());
				repaymentMap.put("orderMemoInfo", borrow.getOrderNo()+"还款");
				repaymentMap.put("notifyUrl", Global.getValue("server_host") + "/pay/lianlian/repaymentNotify.htm");
				RepaymentModel repayment = (RepaymentModel) LianLianHelper.repayment(repaymentMap);

				logger.info("周期性-borrowReapyId：" + borrowRepay.getId() + "-lianlian repayment response: "+ repayment );
				logger.info("周期性-getOrderNo:" + repayment.getOrderNo() + "-getAmount: "+ repayment.getAmount() + "-getRet_msg(): "+ repayment.getRet_msg());

				PayLog payLog = new PayLog();
				payLog.setOrderNo(repayment.getOrderNo());
				payLog.setUserId(borrowRepay.getUserId());
				payLog.setBorrowId(borrowRepay.getBorrowId());
				payLog.setAmount(repayment.getAmount());
				payLog.setCardNo(bankCard.getCardNo());
				payLog.setBank(bankCard.getBank());
				payLog.setSource(PayLogModel.SOURCE_FUNDS_OWN);
				payLog.setType(PayLogModel.TYPE_COLLECT);
				payLog.setScenes(PayLogModel.SCENES_REPAYMENT);
				payLog.setState(PayLogModel.STATE_PAYMENT_WAIT);
				payLog.setRemark(repayment.getRet_msg());
				payLog.setPayReqTime(payReqTime);
				payLog.setCreateTime(DateUtil.getNow());
				payLogService.save(payLog);

				succeed++;
				total++;
			} catch (Exception e) {
				fail++;
				total++;
				logger.error(e.getMessage(), e);
			}
		}
		
		quartzRemark = "处理总数"+total+"个，成功"+succeed+"个，失败"+fail+"个";
		logger.info("代扣还款任务，执行完毕，" + quartzRemark);
		return quartzRemark;

	}

	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
		QuartzInfoService quartzInfoService = (QuartzInfoService) BeanUtil.getBean("quartzInfoService");
		QuartzLogService quartzLogService = (QuartzLogService) BeanUtil.getBean("quartzLogService");
		// 查询当前任务信息
		QuartzInfo quartzInfo = quartzInfoService.findByCode("doRepaymentPeriodic");
		Map<String, Object> qiData = new HashMap<>();
		qiData.put("id", quartzInfo.getId());

		QuartzLog quartzLog = new QuartzLog();
		quartzLog.setQuartzId(quartzInfo.getId());
		quartzLog.setStartTime(DateUtil.getNow());
		try {
			String remark = repayment();
			quartzLog.setTime(DateUtil.getNow().getTime() - quartzLog.getStartTime().getTime());
			quartzLog.setResult("10");
			quartzLog.setRemark(remark);
			qiData.put("succeed", quartzInfo.getSucceed() + 1);
		} catch (Exception e) {
			quartzLog.setResult("20");
			qiData.put("fail", quartzInfo.getFail() + 1);
			logger.error(e.getMessage(), e);
		} finally {
			logger.info("保存代扣还款定时任务执行记录");
			quartzLogService.save(quartzLog);
			quartzInfoService.update(qiData);
		}

	}
}