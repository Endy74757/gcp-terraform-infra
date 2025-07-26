# 🚀 Infra Portfolio: Modern Cloud Infrastructure Automation

## 👋 แนะนำโปรเจกต์

โปรเจกต์นี้แสดงศักยภาพของการออกแบบและบริหารจัดการโครงสร้างพื้นฐาน (Infrastructure) แบบอัตโนมัติเต็มรูปแบบ ด้วย **Terraform** และ **Ansible** ครอบคลุมทั้งการ Provisioning, Configuration, และ Application Deployment บน Google Cloud Platform (GCP) และเซิร์ฟเวอร์ Linux

---

## 🏗️ จุดเด่นของโปรเจกต์

- **Infrastructure as Code (IaC):** ใช้ Terraform สร้างและจัดการ Network, VM, Firewall, API ฯลฯ บน GCP แบบโมดูลาร์
- **Automated Configuration:** ใช้ Ansible ติดตั้งและคอนฟิก Jenkins, HAProxy, Squid Proxy, Docker, Kubernetes และ System Proxy อัตโนมัติ
- **Best Practices:** แยกโมดูล, ใช้ Template, กำหนด Inventory, และรองรับการขยายระบบในอนาคต
- **Security & Flexibility:** กำหนด User, Key, และ Environment Variable อย่างปลอดภัยและยืดหยุ่น

---

## 🗂️ โครงสร้างโปรเจกต์

```
infra/
├── Terraform/         # โค้ด IaC สำหรับ Provisioning GCP Infrastructure
│   ├── compute/       # โมดูล VM
│   ├── network/       # โมดูล VPC, Subnet, Firewall
│   ├── Service/       # โมดูลเปิดใช้งาน API
│   └── templates/     # Template สำหรับ Inventory
├── Ansible/           # Playbook สำหรับ Configuration Management
│   ├── templates/     # Template สำหรับ Proxy
│   ├── main.yaml      # Playbook หลัก (รวมทุก Automation)
│   ├── inventory.ini  # กำหนดกลุ่มเซิร์ฟเวอร์
│   └── ...            # Playbook สำหรับ Jenkins, HAProxy, Squid, Docker, K8s
└── .gitignore
```

---

## 🛠️ เทคโนโลยีที่ใช้

- **Terraform**: Provisioning GCP (VM, Network, Firewall, API)
- **Ansible**: Automation ติดตั้งและคอนฟิก Jenkins, HAProxy, Squid Proxy, Docker, Kubernetes
- **GCP**: Cloud Provider หลัก
- **Linux/Ubuntu**: ระบบปฏิบัติการเป้าหมาย

---

## 🧩 รายละเอียด Automation

### Terraform Modules

- **compute/**: สร้าง VM หลายเครื่อง, กำหนด Tag, Public/Private IP, IP Forwarding
- **network/**: สร้าง VPC, Subnet, Firewall Rules
- **Service/**: เปิดใช้งาน GCP API ที่จำเป็น
- **templates/**: Template สำหรับ Dynamic Inventory

### Ansible Playbooks

- **main.yaml**: รวมทุก Playbook สำหรับ Automation
- **Deploy-jenkins.yaml**: ติดตั้ง Jenkins, Java, ตั้งค่า Repository, Start Service
- **Deploy-config-Haproxy.yaml**: ติดตั้ง HAProxy, เพิ่ม Config สำหรับ Jenkins, Start Service
- **Deploy-config-Squidproxy.yaml**: ติดตั้ง Squid, เพิ่ม ACL สำหรับ Network, Start Service
- **Configure-HTTP-HTTPS-proxy.yaml**: ตั้งค่า Proxy System-wide
- **Deploy-docker.yaml**: ติดตั้ง Docker และ Dependency
- **Deploy-k8s.yaml**: ติดตั้ง Kubernetes, Containerd, ตั้งค่า Proxy, เปิด IP Forward, ฯลฯ
- **Deploy-k8sForJenkins.yaml**: ติดตั้ง K8s CLI บน Jenkins Node

### Inventory Example

```ini
[internal]
elkstack ansible_host=192.168.3.5
jenkins ansible_host=192.168.3.4

[internet-facing]
control ansible_host=192.168.1.7
haproxy ansible_host=192.168.1.5
squidproxy ansible_host=192.168.1.6

[private]
k8s ansible_host=192.168.2.3
```

---

## 🌟 ผลงานที่ได้

- Provision ระบบ Cloud Infrastructure อัตโนมัติ (GCP)
- ติดตั้งและคอนฟิก Jenkins CI/CD, HAProxy Load Balancer, Squid Proxy, Docker, Kubernetes Cluster
- กำหนด Network Security, Proxy, และ System Environment แบบครบวงจร
- พร้อมต่อยอดสู่ Production หรือใช้เป็นต้นแบบสำหรับองค์กร

---

## 🧑‍💻 เกี่ยวกับผู้พัฒนา

**supalurk chalermueang**  
DevOps | Cloud Engineer | Automation Enthusiast  
- เชี่ยวชาญ IaC, Automation, Cloud, Linux  
- สนใจงานออกแบบระบบที่ยืดหยุ่น ปลอดภัย และดูแลง่าย
- GitHub: [https://github.com/Endy74757](https://github.com/Endy74757)
- Email: supalurk.ch@gmial.com

---

> *Portfolio นี้แสดงความสามารถในการออกแบบและดูแลระบบ Infrastructure Automation อย่างมืออาชีพ พร้อมนำไปใช้จริงหรือปรับแต่งต่อยอดได้ทันที* 