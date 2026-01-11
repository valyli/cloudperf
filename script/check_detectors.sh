#!/bin/bash
# 检查所有部署的检测器状态

DEPLOY_REGION="${CDK_DEFAULT_REGION:-us-east-1}"

echo "=== CloudPerf 检测器状态监控 ==="
echo "部署区域: ${DEPLOY_REGION}"
echo "检查时间: $(date)"
echo

# 获取ALB地址
alb_host=$(aws cloudformation describe-stacks --stack-name CloudperfStack --query 'Stacks[0].Outputs[?OutputKey==`albHost`].OutputValue' --output text --region ${DEPLOY_REGION})
if [ "${alb_host}" == "" ]; then
    echo "❌ 无法获取ALB地址，请检查CloudperfStack是否部署成功"
    exit 1
fi

echo "🌐 系统地址: http://${alb_host}"
echo

# 统计所有实例
total_instances=0
running_instances=0
regions_with_instances=()

echo "📊 实例状态统计:"
echo "区域                    实例ID              状态      类型        公网IP"
echo "--------------------------------------------------------------------"

for region in $(aws ec2 describe-regions --query 'Regions[].RegionName' --output text); do
    instances=$(aws ec2 describe-instances --region $region \
        --filters "Name=tag:CostCenter,Values=cloudperf-stack" \
                  "Name=instance-state-name,Values=running,pending,stopping,stopped" \
        --query 'Reservations[].Instances[].[InstanceId,State.Name,Tags[?Key==`Name`].Value|[0],PublicIpAddress]' \
        --output text 2>/dev/null)
    
    if [ ! -z "$instances" ]; then
        regions_with_instances+=($region)
        while IFS=$'\t' read -r instance_id state name public_ip; do
            if [ ! -z "$instance_id" ]; then
                printf "%-20s %-18s %-8s %-10s %s\n" "$region" "$instance_id" "$state" "$name" "$public_ip"
                total_instances=$((total_instances + 1))
                if [ "$state" == "running" ]; then
                    running_instances=$((running_instances + 1))
                fi
            fi
        done <<< "$instances"
    fi
done

echo
echo "📈 统计信息:"
echo "  总实例数: $total_instances"
echo "  运行中: $running_instances"
echo "  覆盖区域: ${#regions_with_instances[@]}"
echo "  区域列表: ${regions_with_instances[*]}"

# 检查系统状态
echo
echo "🔍 系统运行状态:"
status_response=$(curl -s --max-time 10 "http://${alb_host}/api/status" 2>/dev/null)
if [ $? -eq 0 ] && [ "$status_response" != "\"not found\"" ]; then
    echo "✅ API状态: 正常"
    echo "📊 状态详情: $status_response"
else
    echo "⚠️  API状态: 无响应或未初始化"
    echo "💡 提示: 可能需要先进行数据库初始化和创建管理员账号"
fi

echo
echo "🛠️  管理命令:"
echo "  查看日志: aws logs tail /aws/lambda/CloudperfStack-admin* --follow"
echo "  初始化DB: ./script/admin_exec.sh exec_sql init_db"
echo "  创建用户: ./script/admin_exec.sh create_user admin"
echo "  终止实例: ./script/terminate_aws_detector.sh"