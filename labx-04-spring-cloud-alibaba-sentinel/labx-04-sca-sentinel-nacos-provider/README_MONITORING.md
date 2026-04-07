# Prometheus + Grafana 监控配置（Windows 版）

## 一、环境说明

- **Prometheus**: 2.37.9 - `E:\tools\prometheus\prometheus-2.37.9.windows-amd64`
- **Grafana**: 4.6.5 - `E:\tools\grafana\grafana-4.6.5.windows-x64\grafana-4.6.5`
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

### 3. 启动 Grafana
进入 Grafana 目录的 bin 文件夹，双击运行：`grafana-server.exe`

---

## 三、访问地址

| 服务 | 地址 | 用户名/密码 |
|------|------|-------------|
| 应用 | http://localhost:8081 | - |
| Prometheus | http://localhost:9090 | - |
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

## 五、配置文件说明

### Prometheus 配置
- 配置文件：`E:\tools\prometheus\prometheus-2.37.9.windows-amd64\prometheus.yml`
- 已配置抓取 demo-provider 应用（端口 8081）

### 应用配置
- pom.xml 已添加：
  - `spring-boot-starter-actuator`
  - `micrometer-registry-prometheus`
  - `micrometer-jvm-extras`
- application.yaml 已配置暴露所有 Actuator 端点
