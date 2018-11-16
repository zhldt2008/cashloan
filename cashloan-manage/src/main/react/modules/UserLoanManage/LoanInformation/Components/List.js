import React from 'react'
import { Table, Modal, Icon, Button } from 'antd';
import Lookdetails from "./Lookdetails";
var repaymentTypeText = { '10': '待审核', '20': '审核中', '30': '通过', '40': '已拒绝', '50': '还款中', '60': '还款完成', '70': '逾期' }
const objectAssign = require('object-assign');
import AddWin from "./AddWin";
export default React.createClass({
    getInitialState() {
        return {
            selectedRowKeys: [], // 这里配置默认勾选列
            loading: false,
            data: [],
            pagination: {
                pageSize: 10,
                current: 1
            },
            canEdit: true,
            visible: false,
            visible1: false,
            visible2: false,
            pictureData: [],
            creditReportData: [],
            rowRecord: [],
            dataRecord: '',
            record: "",
            visibleAdd: false,

        };
    },

    componentWillReceiveProps(nextProps, nextState) {
        this.fetch(nextProps.params);
    },

    componentDidMount() {
        this.fetch();
        []
    },

    fetch(params = {}) {
        this.setState({
            loading: true
        });
        if (!params.pageSize) {
            var params = {};
            params = {
                pageSize: 10,
                current: 1
            }
        }
        Utils.ajaxData({
            url: '/modules/manage/borrow/borrowRepayList.htm',
            method: "post",
            data: params,
            callback: (result) => {
                const pagination = this.state.pagination;
                pagination.current = params.current;
                pagination.pageSize = params.pageSize;
                pagination.total = result.page.total;
                if (!pagination.current) {
                    pagination.current = 1
                }
                ;
                this.setState({
                    loading: false,
                    data: result.data,
                    pagination
                });
            }
        });
    },

    //查看弹窗
    showModal(title, record, canEdit) {

        this.setState({
            visible: true,
            canEdit: canEdit,
            record: record,
            title: title
        }, () => {
            Utils.ajaxData({
                url: '/modules/manage/borrow/borrowRepayContent.htm',
                data: {
                    borrowId: record.indentNo
                },
                method: "post",
                callback: (result) => {
                    this.refs.Lookdetails.setFieldsValue(result.data);
                    this.setState({
                        dataRecord: result.data,
                    });
                }
            });
        })
    },
    //新增
    addModal(title) {
        Utils.ajaxData({
            url: '/modules/manage/user/list.htm',
            method: "post",
            callback: (result) => {
                this.setState({
                    dataRecord: result.data.list,
                    visibleAdd: true,
                    title: title,
                });
            }
        });

    },
    //隐藏弹窗
    hideModal() {
        this.setState({
            visible: false,
            visible1: false,
            visible2: false,
            selectedIndex: '',
            selectedRowKeys: [],
            visibleAdd: false,
            dataRecord: ''
        });
        this.refreshList();
    },
    rowKey(record) {
        return record.id;
    },

    //选择
    onSelectChange(selectedRowKeys) {
        this.setState({
            selectedRowKeys
        });
    },

    //分页
    handleTableChange(pagination, filters, sorter) {
        const pager = this.state.pagination;
        pager.current = pagination.current;
        this.setState({
            pagination: pager,
        });
        this.refreshList();
    },

    refreshList() {
        var pagination = this.state.pagination;
        var params = objectAssign({}, this.props.params, {
            current: pagination.current,
            pageSize: pagination.pageSize
        });
        this.fetch(params);
    },

    //行点击事件
    onRowClick(record) {
        //console.log(record)
        this.setState({
            selectedRowKeys: [record.id],
            selectedRow: record,
            rowRecord: record
        }, () => {
            this
        });
    },

    // 列表添加选中行样式
    rowClassName(record) {
        let selected = this.state.selectedIndex;
        //console.log('selected', this.state.selectedIndex)
        return (record.id == selected && selected !== '') ? 'selectRow' : '';

    },

    //选择
    onSelectAll(selected, selectedRowKeys, selectedRows, changeRows) {
        if (selected) {
            this.setState({
                selectedRowKeys
            })
        } else {
            this.setState({
                selectedRowKeys: []
            })
        }
    },

    render() {
        const {
            loading,
            selectedRowKeys
            } = this.state;
        const rowSelection = {
            type: 'checkbox',
            selectedRowKeys,
            onSelectAll: this.onSelectAll,
        };
        let me = this;
        const hasSelected = selectedRowKeys.length > 0;
        let openEdit = true;
        if (hasSelected && selectedRowKeys.indexOf("0") === -1) {
            openEdit = false;
        }
        var columns = [{
            title: '真实姓名',
            dataIndex: 'lastName'
        }, {
            title: '手机号码',
            dataIndex: 'mobile'
        }, {
            title: '订单号',
            dataIndex: 'indentNo'
        }, {
            title: '借款金额',
            dataIndex: 'balance'
        }, {
            title: '借款期限(Days)',
            dataIndex: "cycle",
        }, {
            title: '订单生成时间',
            dataIndex: 'createdTime'
        }, {
            title: '综合费用',
            dataIndex: "totalFee"
        }, {
            title: '实际到账金额',
            dataIndex: 'actualBalance'
        }, {
            title: '实际还款金额',
            dataIndex: 'actualbackAmt'
        }, {
            title: '订单状态',
            dataIndex: "status",
            render: (text, record) => {
                if (text == 1){
                return "申请中,待风控审核"
                }else if (text == 2){
                return "风控审核通过,待复审"
                }else if (text == 3){
                return "复审通过,待放款"
                }else if (text == 4){
                return "放款中"
                }else if (text == 5){
                return "已放款,待还款"
                }else if (text == 6){
                return "正常还款"
                }else if (text == 21){
                return "已逾期"
                }else if (text == 22){
                return "逾期还款"
                }else if (text == 31){
                return "风控审核不通过"
                }else if (text == 32){
                return "复审不通过"
                }else if (text == 41){
                return "放款失败"
                }else if (text == 42){
                return "放款被拒"
                }else if (text == 51){
                return "坏账"
                }else{
                    return " "
                }
            }
        },{
            title: '渠道名称',
            dataIndex: 'applyTerminal',
            render: (text, record) => {
            if (text == 1){
                    return "android"
                }else if(text == 2){
                    return "IOS"
                }else{
                return "pc"
            }
            }
        }, {
            title: '操作',
            dataIndex: "",
            render: (value, record) => {
                return (
                    <div style={{ textAlign: "left" }}>
                        <a href="#" onClick={me.showModal.bind(me, '查看详情', record, false)}>查看详情</a>
                    </div>
                )
            }
        }];

        var state = this.state;
        return (
            <div className="block-panel">
                <div className="actionBtns" style={{ marginBottom: 16 }}>
                    {/*<Button onClick={me.addModal.bind(me, '新增')}>
                        新增(测试)
                    </Button>*/}
                </div>
                <Table columns={columns} rowKey={this.rowKey} ref="table"
                    onRowClick={this.onRowClick}
                    dataSource={this.state.data}
                    rowClassName={this.rowClassName}
                    pagination={this.state.pagination}
                    onChange={this.handleTableChange}
                />
                <Lookdetails ref="Lookdetails" visible={state.visible} title={state.title} hideModal={me.hideModal} record={state.record}
                    canEdit={state.canEdit} />
                <AddWin ref="AddWin" dataRecord={state.dataRecord} visible={state.visibleAdd} hideModal={me.hideModal} title={state.title} />
            </div>
        );
    }
})
