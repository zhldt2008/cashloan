<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="apple-mobile-web-app-status-bar-style" content="#7CD88E"/>
	<title>【现金贷用户借款协议】</title>
	<script src="/static/js/mobile.js"></script>
    <script src="/static/js/zepto.min.js"></script>
    <script type="text/javascript">
        function GetQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]);
            return null;
        }

        function initPage() {
            var userId = GetQueryString("userId");
            var borrowId = GetQueryString("borrowId");
            $.ajax({
                url: "${apppath}/api/protocol/borrow.htm",
                type: 'POST',
                dataType: "json",
                data: {
                    "userId": userId,
                    "borrowId": borrowId
                },
                success: function (data) {
                    $("#order_no").html(data.protocolBuyLater.order_no);
                    $("#userName").html(data.protocolBuyLater.userName);
                    $("#userPhone").html(data.protocolBuyLater.userPhone);
                    $("#userIdCard").html(data.protocolBuyLater.userIdCard);
                    $("#userAddress").html(data.protocolBuyLater.userAddress);
                    $("#borrowAmount").html(data.protocolBuyLater.borrowAmount);
                    $("#borrowAmountCapital").html(data.protocolBuyLater.borrowAmountCapital);

                    $("#loanDate").html(data.protocolBuyLater.loanDate);
                    $("#startDate").html(data.protocolBuyLater.loanDate);
                    $("#repayDate").html(data.protocolBuyLater.repayDate);
                    $("#timeLimit").html(data.protocolBuyLater.timeLimit);
                    $("#endDate").html(data.protocolBuyLater.repayDate);
                    $("#totalFee").html(data.protocolBuyLater.totalFee);
                    $("#totalFeeCapital").html(data.protocolBuyLater.totalFeeCapital);
                    $("#userRealName").html(data.protocolBuyLater.userName);

                    $("#cardNo").html(data.protocolBuyLater.cardNo);
                    $("#userRealName").html(data.protocolBuyLater.userName);
                    $("#bankName").html(data.protocolBuyLater.bankName);
                    $("#serviceFee").html(data.protocolBuyLater.serviceFee);
                    $("#customerName").html(data.protocolBuyLater.userName);
                    $("#today").html(data.protocolBuyLater.loanDate);
                    $("#today1").html(data.protocolBuyLater.loanDate);
                }
            });
        }
    </script>
	<link rel="stylesheet" type="text/css" href="/static/css/general.css"/>
<style type="text/css">
body {
	font-size: .875rem;
}

html, body, div, span, h1, h2, h3, p, em, img, dl, dt, dd, ol, ul, li,
	table, tr, th, td, form, input, select {
	margin: 0;
	padding: 0;
}

    body {
        min-width: 320px;
        max-width: 480px;
        min-height: 100%;
        margin: 0 auto;
    }
    .proto{
        padding:30px;
    }
    .proto .text{
        padding-bottom:10px;
    }
    .proto .text li{
        padding-bottom:5px;
        line-height:20px;
    }
    .t{
        color:red;
        border-bottom:1px solid red;
    }
    .proto em{ color:red;}
    .proto h2{ height:33px; line-height: 33px; font-size:16px; font-weight:bold;}

    .tab{ margin:10px 0; border-top:1px solid #ddd; border-left:1px solid #ddd; }
    .tab td,.tab th{
        padding:4px;
        border-right:1px solid #ddd;
        border-bottom:1px solid #ddd;
        font-size:.75rem;
    }
    .chidren li{
        line-height:20px;
        padding-bottom:5px;
    }
</style>
</head>
<body onload="initPage()">
<div style='height:40px;'>
    <div style='float: left;'>《三方协议》</div>
    <div style='float: right ;'>编号：<span id="order_no"></span></div>
    <div style='height:1px;background:#000;clear: both'></div>
</div>
<h1 class="toph2" style="text-align: center;font-size: 24px;">三方协议</h1>
<div class="proto">
	<div class="text">
        <ul>
            <li>
                甲方：【廖群英】，平台账户号：【liaoqunying】。
            </li>
            <li>
                乙方：【<span id="userName"></span>】，平台账户名：【<span id="userPhone"></span>】，
                身份证号：【<span id="userIdCard"></span>】，地址：【<span id="userAddress"></span>】。
            </li>
            <li>
                丙方：厦门左粒网络科技有限公司，平台账户名：【zuolikeji】
            </li>
            <li>
                甲、乙双方是丙方平台（丙方平台指丙方经营的或丙方合作方经营的平台，下称“丙方平台”）的注册用户。乙方因个人购买商品或享受相关服务需向甲方借款，丙方愿意为甲、乙双方的上述交易提供相应的服务，为此，协议三方达成如下条款，以昭信守。
            </li>
        </ul>
	</div>
    <h2>一、借款</h2>
    <div class="chidren">
        <ul>
            <li>1.	乙方将向甲方借款，用于个人购买商品或享受相关服务，并承诺按月向甲方还本付息。乙方不得将所借款项用于借款用途以外的目的。</li>
            <li>
                <table class="tab" cellpadding="0" cellspacing="0">
                    <tr>
                        <th width="80">借款本金</th>
                        <td colspan="2">人民币：<span id="borrowAmount"></span>元</th>
                        <td width="160">大写（人民币）：<span id="borrowAmountCapital"></span></th>
                    </tr>
                    <tr>
                        <th width="80">借款用途</th>
                        <td>个人日常消费</th>
                        <td>放款日</td>
                        <td><span id="loanDate"></span></td>
                    </tr>
                    <tr>
                        <th>借款期限</th>
                        <td colspan="3"><span id="startDate"></span>至<span id="repayDate"></span>,共计<span id="timeLimit"></span>天</td>
                    </tr>
                    <tr>
                        <th>到期还款日</th>
                        <td colspan="3"><span id="endDate"></span></td>
                    </tr>
                    <tr>
                        <th width="80">到期还款本息和综合费用总额</th>
                        <td colspan="2">人民币：<span id="totalFee"></span>元</td>
                        <td width="160">大写：<span id="totalFeeCapital"></span></td>
                    </tr>
                </table>
            </li>
            <li>
                2.	本协议项下的借款用途为借款明细表列明的借款用途，乙方不得将所借款项用于借款用途以外的目的。
            </li>
            <li>3.	放款：本协议签订并生效后的5个工作日内，丙方根据甲方的授权将借款打入乙方如下银行账户（下称“乙方账户”）
                ： 账户名：【<span id="userRealName"></span> 】；账号：【<span id="cardNo"></span>】；开户银行：【<span id="bankName"></span>】。丙方依据本款规定实际向乙方账户支付了上述第一款规定的借款本金，则甲方在本协议项下的放款义务完成。丙方实际向乙方账户打款的日期即为放款日（下称“实际放款日”），如果实际放款日与借款明细表记载的放款日不一致，则以实际放款日为准，并且借款明细表中的最终到期日将根据实际放款日相应调整。对于实际放款日、实际最终到期日，乙方可以通过丙方平台查询。甲方委托丙方向乙方放款的相关约定由甲方与丙方的相关协议规定。
            </li>
        </ul>
    </div>
    <h2>二、还款</h2>
    <div class="chidren">
        <ul>
            <li>1.	乙方应按本协议规定向甲方归还本金并支付利息；如发生逾期还款，乙方需按本协议约定向甲方支付逾期违约金和逾期还款滞纳金。乙方应支付的上述款项统称为“乙方应付款项”。</li>
            <li>2.	乙方应于到期还款日或之前向甲方归还全部乙方应付款项。到期还款日是指本借款明细表中约定的还款日，还款本金和利息数额为借款明细表中约定的还款本息总额。</li>
            <li>
                3.	乙方应按照以下方式进行还款：<Br>
                乙方不可撤销地授权丙方或丙方指定的第三方机构在还款日从上述第一条第3款规定的乙方账户中扣除相应的款项，并将扣款转至甲方认可的账户，用于向甲方偿还乙方应偿还的当期应付款项。
            </li>
            <li>4.	乙方根据本协议的规定对丙方和/或丙方指定的第三方机构的授权期间：自本协议生效日起，至乙方清偿其在三方协议项下应归还和支付的全部钱款后止。乙方在授权期限内不可撤销其根据本授权对丙方和/或丙方指定的第三方机构的全部或部分授权。</li>
            <li>5.	归还日期：当期应付款的成功偿还日期应以相应款项到达甲方账户或甲方的银行账户之日为准。</li>
        </ul>
    </div>
    <h2>三、逾期还款</h2>
    <div class="chidren">
        <ul>
            <li>1.	到期还款日的24:00时前，乙方未足额支付当月应还款项的，则视为逾期。</li>
            <li>2.	乙方逾期的，除应付本金、利息外应当另行支付逾期违约金和逾期还款滞纳金（上述款项合称为“逾期款项”）。</li>
            <li>3.	滞纳金10元/笔加逾期小于等于15天，按逾期当期本金的0.5%/天收取，逾期大于15天，按逾期金额的0.75%/ 天收取直至还款。</li>
            <li>4.	如乙方的还款金额不足以支付全部逾期款项，乙方应按如下顺序支付：A.逾期还款滞纳金；B.逾期违约金；C.丙方应收取的一次性服务费； D.利息；E.本金。</li>
            <li>5.	乙方可以登录丙方平台账户查阅到期本金利息以及应支付的逾期还款滞纳金和逾期违约金。</li>
            <li>6.	当乙方存在逾期款项时，乙方应当按本条第2款的规定，支付逾期还款滞纳金、逾期违约金、利息和本金，并且乙方已支付给丙方的任何服务费用不作退还。</li>
            <li>7.	当乙方存在逾期还款情形时，应立即履行还款义务。甲方有权自己或授权丙方或丙方的合法受托人，以包括电话、手机短信、电子邮件或其他合法方式提醒并催告乙方履行还款义务。 乙方已充分阅读且理解本项规定含义，并完全同意。</li>
            <li>8.	甲方可随时将对乙方之债权（包括但不限于借款本金、利息、逾期违约金、逾期还款滞纳金等，以下同）转让给丙方或任何其他人，并授权丙方或丙方指定的其他人以其自身名义向乙方发送债权转让通知，丙方依据本协议向乙方发送的债权转让通知视同甲方所发，乙方认可该等债权转让通知与甲方所发的债权转让通知具有同等法律效力， 乙方不会对该等债权转让通知的效力及相关的债权转让效力提出任何异议。丙方或其他人取得对乙方之债权后，可依法再行转让。因乙方逾期还款，债权人为实现债权而发生的所有费用，包括但不限于律师费、调查费、催收费、保全费等相关费用均由乙方承担。</li>
            <li>9.	如发生银行代扣出现问题等不可控因素导致还款未成功，请联系客服处理（微信公众号：“小粒同学”，点击下方“在线客服”）。</li>
        </ul>
    </div>
    <h2>四、丙方的服务费</h2>
    <div class="chidren">
        <ul>
            <li>1.	乙方应在本协议签订之日向丙方支付一次性服务费人民币【<span id="serviceFee"></span> 】元（下称“一次性服务费”）。乙方应保证乙方账户有足够的资金，并不可撤销地授权丙方从乙方账户中将一次性服务费划转至丙方账户。</li>
            <li>2.	乙方充分理解，其所支付给丙方的服务费是其接受丙方的服务而应支付的合理费用，本协议签订并实际履行后，如因任何原因而导致甲方和乙方之间的借款合同关系终止或提前解除，乙方无权要求丙方退还其已支付的服务费。</li>
        </ul>
    </div>
    <h2>五、陈述与保证</h2>
    <div class="chidren">
        <ul>
            <li>1.	甲方和乙方充分理解，甲方和乙方是本协议项下借款关系的合同主体，关于借款关系的权利与义务由甲方和乙方享有和承担。</li>
            <li>2.	乙方充分理解，其所支付给丙方的服务费并非借款利息，而是其接受丙方的服务而应支付的合理报酬。</li>
            <li>3.	乙方承诺并保证，其所提供的信息均为真实、完整和有效。如乙方的任何个人信息发生变更，乙方应当在变更发生之日起3个工作日内通知甲方和丙方，若乙方未及时告知该变更，因此而造成的任何后果、损失和费用，将由乙方自行承担
                。
            </li>
            <li>4.	乙方在此不可撤销地授权甲方和丙方向包括但不限于百融金融信息服务股份有限公司、深圳市和讯华谷信息技术有限公司、北京融世纪信息技术有限公司、杭州博盾习言科技有限公司以及任何其他合法设立的征信机构运营的信用信息系统之中，供具有适当资格的单位/个人查询和使用，并用于相关法律、法规、规章和规范性文件规定的用途和本协议约定的用途。</li>
            <li>5.	甲乙双方不可撤销地同意，丙方可以使用并向其投保的保险公司披露甲乙双方的个人信息、本协议、本协议项下的事宜以及与此等事宜有关的任何文件、资料或信息。</li>
            <li>6.	甲方保证其向乙方出借的资金为自有资金，且来源均合法。</li>
            <li>7.	乙方同意其个人信息可供甲方和丙方今后为其提供其他服务使用。</li>
            <li>8.	当乙方发生本合同项下的违约时，甲方和丙方有权根据乙方的违约情况决定公开乙方的违约信息，并且乙方在此不可撤销地同意并授权甲方和丙方将有关本合同的信息、乙方提供的其他信息、乙方个人信用信息、信用报告和信用评价披露给有关的催收机构、保险机构、银行、其它金融机构、以及任何合法设立的征信机构、以及律师事务所，并不可撤销的授权甲方和丙方将上述信息提供给第三方，以便第三方对于到期未归还借款进行催收、处置等。</li>
        </ul>
    </div>
    <h2>六、违约</h2>
    <div class="chidren">
        <ul>
            <li>1.	发生下列任何一项或几项情形的，视为乙方违约：
                <ul>
                    <li>（1）乙方违反其在本协议项下的任何义务、承诺或保证的；</li>
                    <li>（2）乙方擅自改变本协议约定的借款用途的；</li>
                    <li>（3）乙方提供虚假资料或故意隐瞒重要事实，影响甲方和丙方评估乙方信用和还款能力的；</li>
                    <li>（4）乙方的任何财产遭受没收、征用、查封、扣押、冻结等可能影响其履约能力的不利事件，且不能及时提供有效补救措施的；</li>
                    <li>（5）乙方的财务状况出现影响其履约能力的不利变化，且不能及时提供有效补救措施的。</li>
                </ul>
            </li>
            <li>
                2.	若乙方违约或根据甲方和丙方合理判断乙方可能发生违约事件的，甲方（委托丙方及其合法受托人）有权采取下列任何一项或几项救济措施：
                <ul>
                    <li>（1）宣布已出借借款全部提前到期，乙方应根据本协议关于提前还款的规定，立即偿还所有应付款项，并承担相应的违约责任；</li>
                    <li>（2）立即解除本协议中关于借款关系部分的内容；</li>
                    <li>（3）采取法律、法规以及本协议约定的其他救济措施。</li>
                </ul>
            </li>
            <li>3.	若乙方违约，应赔偿甲方和/或丙方因此遭受的损失，包括由此产生的律师费、调查费、催收费等其他费用；并且，在乙方违约的情况下，乙方已经支付给丙方的任何服务费用均不予退还。</li>
        </ul>
    </div>
    <h2>七、保密条款</h2>
    <div class="chidren">
        <ul>
            <li>
                1.	本协议签署后, 除非另有约定或事先得到各方的书面同意, 本协议各方均应承担以下保密义务：
                <ul>
                    <li>（1）任何一方不得向非本协议方（丙方及其委托的第三方服务商/合作方除外）披露本协议以及本协议项下的事宜以及与此等事宜有关的任何文件、资料或信息（“保密信息”）；</li>
                    <li>
                        （2）任何一方只能将保密信息和其内容用于本协议项下的目的, 不得用于任何其他目的。本款的约定不适用于下列保密信息：
                        <p>A.从披露方获得时，已是公开的；</p>
                        <p>B.从披露方获得前，接受方已经获知的；</p>
                        <p>C.从有正当权限并不受保密义务制约的第三方获得的；</p>
                        <p>D.非依靠披露方披露或提供的信息独自开发的。</p>
                    </li>
                </ul>
            </li>
            <li>2.	因下列原因披露保密信息，不受前款的限制：
                <ul>
                    <li>（1）向本协议各方聘请的会计师、律师、咨询公司披露；</li>
                    <li>（2）因遵循可适用的法律、法规的强制性规定而披露；</li>
                    <li>（3）依据其他应遵守的法规向审批机构和/或权力机构进行的披露；</li>
                    <li>（4）为服务于本协议项下的目的，向相关第三方披露的。</li>
                </ul>
            </li>
            <li>3.	本协议任何一方应采取所有其他必要、适当和可以采取的措施，以确保保密信息的保密性。</li>
            <li>4.	本协议各方应促使其向之披露保密信息的第三方严格遵守本条约定。</li>
            <li>5.	各方在本条项下的权利和义务应在本协议终止或到期后继续有效。</li>
        </ul>
    </div>
    <h2>八、通知</h2>
    <div class="chidren">
        <ul>
            <li>1.  本协议任何一方根据本协议约定做出的通知和/或文件均应以书面形式（包括但不限于电子邮件、手机短信、丙方平台信息公告、站内信等方式）发出，各方根据本协议发出的所有通知均为合法有效的通知。</li>
            <li>2.	若本协议任何一方更改其联系人或联系地址或电子邮件邮箱地址，应尽快按本条约定在相关信息变更之日起3个工作日内书面通知各方。</li>
            <li>3.	各方还在此确认，如果各方因本合同的签订和履行而发生争议，则上述地址也将作为争议解决机构（包括法院和仲裁机构）送达相关通知和文书的有效送达地址。</li>
        </ul>
    </div>
    <h2>九、	法律适用和管辖</h2>
    <div class="chidren">
        <ul>
            <li>本协议的签订、履行、终止、解释均适用中国法律。各方同意，因本协议所产生的或与本协议有关的一切争议，各方应协商解决；协商无法达成一致的，均应提交协议签约地所在的上海虹口区人民法院进行诉讼。</li>
        </ul>
    </div>
    <h2>十、	其他</h2>
    <div class="chidren">
        <ul>
            <li>1.	各方授权丙方可应任一方的合理要求，向其提供另一方提供给丙方的所有信息。丙方亦有义务随时应甲方要求向甲方提供涉及乙方的任何信息或资料。</li>
            <li>2.	甲方和丙方保留将乙方违约失信的相关信息在丙方平台或其他媒体披露的权利。</li>
            <li>3.	本协议的传真件、复印件、扫描件等复本或其它形式的电子副本等同于原件的法律效力。</li>
            <li>4.	甲乙丙三方均确认，本协议的签署，生效和履行以不违反中国的法律法规为前提，如本协议中的任何一条或多条违反适用的法律法规，则该条将被视作无效，但该无效条款并不影响本协议其他条款的法律效力。</li>
            <li>5.	本协议各方理解，甲方对乙方的借款条件尚需审核，如果甲方审核后不同意向乙方借款，并且甲方最终没有签署本协议
                ，则乙方不可撤销地同意并授权丙方寻找愿意将资金出借给乙方的新的出借方（“新的资金出借方”）。当丙方根据本条规定为乙方寻找到新的资金出借方，则乙方和丙方不可撤销地同意，由新的资金出借方作为本协议的甲方，在此情况下，本协议将在新的资金出借方以及乙方和丙方之间生效并实际履行，并且本协议的各项条款内容均维持不变。
            </li>
            <li>6.	乙方确认已经充分阅读并理解本协议各项条款，本协议签署后即代表乙方对本协议无异议，乙方将无条件同意按照本协议约定履行。</li>
        </ul>
    </div>
    <div>
        <table class="tab" cellpadding="0" cellspacing="0">
            <tr>
                <th height="150" width="170">
                    <div align="left" valign="top">甲方：廖群英</div>
                    <div align="left" valign="bottom">日期:<span id="today"></span></div>
                </th>
                <th width="170" align="left">乙方：<span id="customerName"></span></th>
            </tr>
            <tr>
                <th height="150" width="150" colspan="2">
                    <div align="left" valign="top">丙方：厦门左粒网络科技有限公司</div>
                    <div align="left" valign="bottom">日期:<span id="today1"></span></div>
                </th>
            </tr>
        </table>
    </div>
</div>
</body>
</html>


