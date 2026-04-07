# Prometheus + Grafana + Alertmanager 监控配置（Windows 版）

## 一、环境说明

- **Prometheus**: 2.37.9 - `E:\tools\prometheus\prometheus-2.37.9.windows-amd64`
- **Grafana**: 4.6.5 - `E:\tools\grafana\grafana-4.6.5.windows-x64\grafana-4.6.5`
- **Alertmanager**: 0.31.1 - `E:\tools\alertmanager\alertmanager-0.31.1.windows-amd64`
- **Spring Boot 应用**: demo-provider - 端口 8081

---

## 二、快速启动（推荐）

项目已提供 `.bat` 启动脚本，**按以下顺序双击运行**：

| 序号 | 启动脚本 | 说明 |
|------|---------|------|
| 1 | `start-prometheus.bat` | 启动 Prometheus（端口 9090） |
| 2 | `start-alertmanager.bat` | 启动 Alertmanager（端口 9093） |
| 3 | 手动启动 Grafana | 进入 `E:\tools\grafana\grafana-4.6.5.windows-x64\grafana-4.6.5\bin`，双击 `grafana-server.exe` |
| 4 | 启动 Spring Boot 应用 | `mvn spring-boot:run`（端口 8081） |

---

## 三、访问地址

| 服务 | 地址 | 用户名/密码 |
|------|------|-------------|
| Spring Boot 应用 | http://localhost:8081 | - |
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

### 当前配置状态
✅ Alertmanager 已配置完成，两个收件人邮箱：
- `15218758857@163.com`
- `371638679@qq.com`

### 告警规则说明
已配置的告警规则（`alerts.yml`）：
- **JVMMemoryHigh**: JVM 堆内存使用率 > 1%（测试用，生产环境建议改为 80%）
- **ProcessCPUHigh**: CPU 使用率 > 70%，持续1分钟
- **GCFrequent**: GC 次数 > 10次/分钟
- **InstanceDown**: 应用实例宕机，持续30秒

### 告警频率配置（当前测试用）
- `group_wait: 10s` - 第一次告警等待 10 秒
- `group_interval: 30s` - 同一组告警间隔 30 秒
- `repeat_interval: 2m` - 相同告警重复间隔 2 分钟

**生产环境建议调整为**：
- `group_wait: 30s`
- `group_interval: 5m`
- `repeat_interval: 1h`

### 查看邮件发送记录
1. **Alertmanager 命令行窗口** - 查看发送成功/失败日志
2. **Alertmanager Web UI** - http://localhost:9093 查看当前告警
3. **发件人邮箱已发送文件夹** - 查看已发送的告警邮件

### 修改收件人或告警配置
编辑 `E:\tools\alertmanager\alertmanager-0.31.1.windows-amd64\alertmanager.yml`，然后重启 Alertmanager。

---

## 六、配置文件说明

### 项目中的配置文件（模板）
| 文件 | 说明 |
|------|------|
| `prometheus.yml` | Prometheus 配置模板 |
| `alerts.yml` | 告警规则模板 |
| `alertmanager.yml` | Alertmanager 配置模板（含 SMTP 设置） |
| `start-prometheus.bat` | Prometheus 启动脚本 |
| `start-alertmanager.bat` | Alertmanager 启动脚本 |

### 实际使用的配置文件
| 文件 | 路径 |
|------|------|
| Prometheus 配置 | `E:\tools\prometheus\prometheus-2.37.9.windows-amd64\prometheus.yml` |
| 告警规则 | `E:\tools\prometheus\prometheus-2.37.9.windows-amd64\alerts.yml` |
| Alertmanager 配置 | `E:\tools\alertmanager\alertmanager-0.31.1.windows-amd64\alertmanager.yml` |

### Spring Boot 应用配置
- **pom.xml** 已添加：
  - `spring-boot-starter-actuator`
  - `micrometer-registry-prometheus`
  - `micrometer-jvm-extras`
- **application.yaml** 已配置暴露所有 Actuator 端点

---

## 七、常见问题

### Q: 修改配置后需要重启吗？
A: 是的，Prometheus 和 Alertmanager 修改配置后都需要重启才能生效。

### Q: 如何临时调整告警阈值快速测试？
A: 编辑 `alerts.yml`，修改 `expr` 表达式中的阈值（如把 80% 改成 1%），然后重启 Prometheus。

### Q: 如何查看告警历史？
A: Alertmanager 本身不持久化历史告警，建议通过 Grafana 查看指标历史，或查看邮箱收件记录。
