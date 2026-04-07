# Prometheus + Grafana 监控配置（Windows 版）

## 一、环境说明

- **Prometheus**: 2.37.9 - `E:\tools\prometheus\prometheus-2.37.9.windows-amd64`
- **Grafana**: 4.6.5 - `E:\tools\grafana\grafana-4.6.5.windows-x64\grafana-4.6.5`
- **Alertmanager**: 需要下载 - `E:\tools\alertmanager\alertmanager-0.31.1.windows-amd64`
- **Spring Boot 应用**: demo-provider - 端口 8081

---

## 二、启动步骤

### 1. 启动 Spring Boot 应用
```bash
cd labx-04-sca-sentinel-nacos-provider
mvn spring-boot:run
```

### 2. 启动 Prometheus
双击运行：`start-prometheus.bat`

### 3. 启动 Alertmanager（邮件预警需要）
双击运行：`start-alertmanager.bat`

### 4. 启动 Grafana
进入 Grafana 目录的 bin 文件夹，双击运行：`grafana-server.exe`

---

## 三、访问地址

| 服务 | 地址 | 用户名/密码 |
|------|------|-------------|
| 应用 | http://localhost:8081 | - |
| Prometheus | http://localhost:9090 | - |
| Alertmanager | http://localhost:9093 | - |
| Grafana | http://localhost:3000 | admin/admin |
| Prometheus 端点 | http://localhost:8081/actuator/prometheus | - |

---

## 四、Grafana 配置 JVM 仪表盘

### 1. 配置 Prometheus 数据源
1. 打开 Grafana：http://localhost:3000
2. 登录（admin/admin）
3. 左侧菜单 → **Data Sources** → **Add data source**
4. 选择 **Prometheus**
5. URL 输入：`http://localhost:9090`
6. 点击 **Save & Test**

### 2. 导入 JVM 仪表盘（ID: 4701）
1. 左侧菜单 → **+** → **Import**
2. 输入仪表盘 ID：**4701**
3. 点击 **Load**
4. 选择 Prometheus 数据源
5. 点击 **Import**

### 3. 仪表盘包含的监控指标
- JVM 内存使用情况
- GC 垃圾回收次数和耗时
- CPU 使用率
- 线程数
- 类加载情况

---

## 五、邮件预警配置（Alertmanager）

### 1. 下载 Alertmanager
- 访问：https://prometheus.io/download/#alertmanager
- 下载 Windows 版本（alertmanager-*.windows-amd64.zip）
- 解压到：`E:\tools\alertmanager`

### 2. 配置 Alertmanager
1. 复制项目中的 `alertmanager.yml` 到 `E:\tools\alertmanager\alertmanager.yml`
2. 编辑 `E:\tools\alertmanager\alertmanager.yml`，填写您的 SMTP 配置：

```yaml
global:
  smtp_smarthost: 'smtp.163.com:465'  # 163邮箱 SMTP 服务器
  smtp_from: 'your_email@163.com'        # 您的163邮箱
  smtp_auth_username: 'your_email@163.com' # SMTP 用户名
  smtp_auth_password: 'your_authorization_code' # 邮箱授权码（不是登录密码！）
  # 163邮箱授权码获取：设置 -> POP3/SMTP/IMAP -> 开启服务 -> 获取授权码

# ... 其他配置保持不变

receivers:
  - name: 'email-notifications'
    email_configs:
      - to: 'recipient_email@example.com'  # 收件人邮箱
```

### 3. 告警规则说明
已配置的告警规则（`alerts.yml`）：
- **JVMMemoryHigh**: JVM 堆内存使用率 > 80%，持续1分钟
- **ProcessCPUHigh**: CPU 使用率 > 70%，持续1分钟
- **GCFrequent**: GC 次数 > 10次/分钟
- **InstanceDown**: 应用实例宕机，持续30秒

### 4. 在 Prometheus 中查看告警
- 打开 Prometheus：http://localhost:9090
- 点击菜单 **Alerts**
- 可以看到所有告警规则和当前状态

### 5. 测试邮件告警
可以通过增加应用负载来触发告警，或者临时调整告警阈值进行测试。

---

## 六、配置文件说明

### Prometheus 配置
- 配置文件：`E:\tools\prometheus\prometheus-2.37.9.windows-amd64\prometheus.yml`
- 已配置：
  - 抓取 demo-provider 应用（端口 8081）
  - 连接 Alertmanager（localhost:9093）
  - 加载告警规则（alerts.yml）

### Alertmanager 配置
- 配置文件：`E:\tools\alertmanager\alertmanager.yml`
- 需自行填写 SMTP 邮件配置

### 应用配置
- pom.xml 已添加：
  - `spring-boot-starter-actuator`
  - `micrometer-registry-prometheus`
  - `micrometer-jvm-extras`
- application.yaml 已配置暴露所有 Actuator 端点
