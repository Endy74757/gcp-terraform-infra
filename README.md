# GCP Terraform Infrastructure

โปรเจกต์นี้ใช้ Terraform เพื่อสร้างและจัดการโครงสร้างพื้นฐานหลัก (Core Infrastructure) บน Google Cloud Platform (GCP) อย่างเป็นระบบและอัตโนมัติ ถูกออกแบบในรูปแบบโมดูลเพื่อให้ง่ายต่อการจัดการ, นำไปใช้ซ้ำ, และขยายความสามารถในอนาคต

## ✨ คุณสมบัติหลัก

- **การจัดการ API อัตโนมัติ**: เปิดใช้งาน Service API ที่จำเป็นสำหรับโปรเจกต์โดยอัตโนมัติ
- **เครือข่ายที่ยืดหยุ่น**: สร้าง VPC Network และ Subnets ได้ตามที่กำหนดในไฟล์คอนฟิก
- **การสร้าง VM แบบไดนามิก**: สร้าง VM instances หลายเครื่องพร้อมกัน โดยแต่ละเครื่องสามารถมี configuration (zone, machine type, public IP) ที่แตกต่างกันได้
- **การติดแท็กอัตโนมัติ**: VM แต่ละเครื่องจะถูกติดแท็ก (Tag) ด้วยชื่อของ Subnet ที่ตัวเองอยู่ (internet-facing, private, internal, etc.) เพื่อให้ง่ายต่อการกำหนด Firewall Rules
- **การจัดการ Firewall แบบครบวงจร**: สร้าง Firewall Rules ที่ซับซ้อนพร้อมกำหนด source ranges, destination ranges, และ ports ได้อย่างยืดหยุ่น
- **การกำหนดค่า IP Forwarding**: รองรับการตั้งค่า IP forwarding สำหรับ VM ที่ทำหน้าที่เป็น proxy หรือ load balancer

## 📁 โครงสร้างโปรเจกต์

```
gcp-terraform-infra/
├── compute/                    # โมดูลสำหรับจัดการ VM instances
├── network/                    # โมดูลสำหรับจัดการ VPC, Subnets และ Firewall Rules
├── Service/                    # โมดูลสำหรับจัดการการเปิดใช้งาน API
├── .gitignore
├── main.tf                     # ไฟล์หลักที่เรียกใช้โมดูลทั้งหมด
├── variables.tf                # ตัวแปรหลักของโปรเจกต์
├── output.tf                   # ผลลัพธ์หลักของโปรเจกต์
├── provider.tf                 # กำหนดค่า GCP provider
├── terraform.tfvars.example    # ตัวอย่างไฟล์กำหนดค่าตัวแปร
└── README.md
```

## 🛠️ ข้อกำหนดเบื้องต้น

- **Terraform**: ติดตั้ง Terraform (เวอร์ชัน 1.2.0 หรือสูงกว่า)
- **Google Cloud SDK**: ติดตั้ง `gcloud` CLI
- **GCP Project**: มีโปรเจกต์ GCP ที่พร้อมใช้งาน

## 🔐 การตั้งค่าการรับรองตัวตน

เราแนะนำให้ใช้วิธี Application Default Credentials (ADC) ซึ่งปลอดภัยและสะดวกที่สุด:

```bash
# ล็อกอินด้วยบัญชี Google ของคุณ
gcloud auth login

# สร้างไฟล์ credentials สำหรับให้แอปพลิเคชัน (เช่น Terraform) ตรวจจับและใช้งานโดยอัตโนมัติ
gcloud auth application-default login
```

Terraform จะตรวจจับและใช้ credentials นี้โดยอัตโนมัติ

## 🚀 การติดตั้งและใช้งาน

### 1. Clone Repository

```bash
git clone https://github.com/Endy74757/gcp-terraform-infra.git
cd gcp-terraform-infra
```

### 2. กำหนดค่าตัวแปร

สร้างไฟล์ `terraform.tfvars` จากตัวอย่าง:

```bash
cp terraform.tfvars.example terraform.tfvars
```

แก้ไขไฟล์ `terraform.tfvars` ให้เหมาะสมกับสภาพแวดล้อมของคุณ:

```hcl
# ID ของโปรเจกต์ GCP ของคุณ
project_id = "terraform-trianning"

# Region ที่ต้องการสร้าง resources
region = "asia-southeast1"

# Service Account Key สำหรับการรับรองตัวตน
credentials = "./terraform-trianning-a9fe9bf713a2.json"

# รายการ API ที่ต้องการเปิดใช้งาน
services = [
  "compute.googleapis.com",
  "iam.googleapis.com",
  "cloudresourcemanager.googleapis.com",
]

# กำหนดค่า VM instances
instance_configs = {
  control = {
    zone             = "asia-southeast1-b"
    machine_type     = "e2-small"
    subnet           = "internet-facing"
    assign_public_ip = true
  },
  haproxy = {
    zone             = "asia-southeast1-b"
    machine_type     = "e2-small"
    subnet           = "internet-facing"
    can_ip_forward   = true
    assign_public_ip = true
  },
  squidproxy = {
    zone             = "asia-southeast1-b"
    machine_type     = "e2-small"
    subnet           = "internet-facing"
    can_ip_forward   = true
    assign_public_ip = true
  },
  k8s = {
    zone         = "asia-southeast1-b"
    machine_type = "e2-medium"
    subnet       = "private"
  },
  jenkins = {
    zone         = "asia-southeast1-b"
    machine_type = "e2-small"
    subnet       = "internal"
  },
  elkstack = {
    zone         = "asia-southeast1-b"
    machine_type = "e2-medium"
    subnet       = "internal"
  }
}

# กำหนดค่า Subnets
subnets_config = {
  "internet-facing" = {
    cidr_range = "192.168.1.0/24"
  },
  "private" = {
    cidr_range = "192.168.2.0/24"
  },
  "internal" = {
    cidr_range = "192.168.3.0/24"
  }
}

# กำหนดค่า Firewall Rules
firewalls_config = {
  "devops-allow-ssh-http-https" = {
    protocol    = "tcp"
    ports       = ["22", "80", "443"]
    description = "Allow inbound SSH (22), HTTP (80), and HTTPS (443) traffic from any source."
    src         = ["0.0.0.0/0"]
  },
  "devops-privateinternal-sqiud" = {
    protocol    = "tcp"
    ports       = ["3128"]
    description = "Allow traffic from private and internal networks to Squid proxy on port 3128."
    src         = ["192.168.2.0/24", "192.168.3.0/24"]
    dest        = ["192.168.1.3"]
  },
  "devops-internet-ha" = {
    protocol    = "tcp"
    ports       = ["5601", "8080", "30800-30805"]
    description = "Allow public internet access to HAProxy for forwarded services."
    src         = ["0.0.0.0/0"]
    dest        = ["192.168.1.4"]
  },
  "devops-ha-jenkins" = {
    protocol    = "tcp"
    ports       = ["8080"]
    description = "Allow traffic to Jenkins server on port 8080."
    src         = ["0.0.0.0/0"]
    dest        = ["192.168.3.3"]
  },
  "devops-ha-elk" = {
    protocol    = "tcp"
    ports       = ["5601"]
    description = "Allow traffic to ELK/Kibana instance on port 5601."
    src         = ["0.0.0.0/0"]
    dest        = ["192.168.3.2"]
  },
  "devops-internetprivate-elk" = {
    protocol    = "tcp"
    ports       = ["5044"]
    description = "Allow Logstash Beats input from internet and private zones to ELK server."
    src         = ["192.168.1.0/24", "192.168.2.0/24"]
    dest        = ["192.168.3.2"]
  },
  "devops-private-internetinternal" = {
    protocol    = "tcp"
    ports       = ["9100"]
    description = "Allow Prometheus/Node Exporter metric scraping on port 9100."
    src         = ["192.168.2.0/24"]
    dest        = ["192.168.3.2", "192.168.1.0/24"]
  },
  "devops-internetinternal-private" = {
    protocol    = "tcp"
    ports       = ["6443", "30800-30805"]
    description = "Allow Kubernetes API and NodePort access to private zone."
    src         = ["192.168.3.2", "192.168.1.0/24"]
    dest        = ["192.168.2.0/24"]
  }
}
```

### 3. Deploy โครงสร้างพื้นฐาน

```bash
# เริ่มต้นโปรเจกต์และดาวน์โหลด providers
terraform init

# (แนะนำ) ตรวจสอบแผนการทำงานก่อน apply
terraform plan

# สร้าง resources ทั้งหมด
terraform apply
```

### 4. ทำลาย Resources

หากต้องการลบ resources ทั้งหมดที่สร้างโดย Terraform:

```bash
terraform destroy
```

## 🔧 ตัวอย่างการใช้งาน

### สร้าง Infrastructure สำหรับ DevOps Pipeline

โปรเจกต์นี้ถูกออกแบบเพื่อสร้าง infrastructure ที่ครบครันสำหรับ DevOps pipeline ประกอบด้วย:

- **Control Node**: เครื่องหลักสำหรับจัดการและควบคุมระบบ
- **HAProxy**: Load balancer สำหรับกระจายการเข้าถึงไปยัง services ต่างๆ
- **Squid Proxy**: Proxy server สำหรับการเข้าถึง internet จาก private networks
- **Kubernetes Cluster**: สำหรับ container orchestration
- **Jenkins**: CI/CD pipeline automation
- **ELK Stack**: สำหรับ centralized logging และ monitoring

### Network Segmentation

- **Internet-facing zone** (192.168.1.0/24): สำหรับ services ที่ต้องการ public access
- **Private zone** (192.168.2.0/24): สำหรับ application workloads
- **Internal zone** (192.168.3.0/24): สำหรับ management และ internal services

## 📋 ตัวแปร (Variables)

| ชื่อ | คำอธิบาย | ประเภท | ค่าเริ่มต้น | จำเป็น? |
|------|-----------|--------|-------------|---------|
| `project_id` | ID ของโปรเจกต์ Google Cloud | string | - | Yes |
| `credentials` | Path ไปยังไฟล์ Service Account JSON key | string | - | Yes |
| `region` | Region ของ GCP ที่จะสร้าง resources | string | "asia-southeast1" | No |
| `services` | รายการ Service API ที่ต้องการเปิดใช้งาน | list(string) | - | Yes |
| `instance_configs` | Map object สำหรับกำหนดค่า VM แต่ละเครื่อง | map(object) | - | Yes |
| `subnets_config` | Map object สำหรับกำหนดค่า Subnet แต่ละโซน | map(object) | - | Yes |
| `firewalls_config` | Map object สำหรับกำหนดค่า Firewall Rules | map(object) | - | Yes |
| `network_name` | ชื่อของ VPC Network ที่จะสร้าง | string | "devops-network" | No |

### รายละเอียด instance_configs

แต่ละ instance ใน `instance_configs` สามารถกำหนดค่าได้ดังนี้:

| ชื่อ | คำอธิบาย | ประเภท | ค่าเริ่มต้น | จำเป็น? |
|------|-----------|--------|-------------|---------|
| `zone` | Zone ที่จะสร้าง VM | string | - | Yes |
| `machine_type` | ประเภทเครื่อง (e2-micro, e2-small, e2-medium, etc.) | string | - | Yes |
| `subnet` | ชื่อ subnet ที่ VM จะอยู่ | string | - | Yes |
| `can_ip_forward` | เปิดใช้งาน IP forwarding (สำหรับ proxy/load balancer) | bool | false | No |
| `assign_public_ip` | กำหนด Public IP ให้กับ VM | bool | false | No |

### รายละเอียด firewalls_config

แต่ละ firewall rule ใน `firewalls_config` สามารถกำหนดค่าได้ดังนี้:

| ชื่อ | คำอธิบาย | ประเภท | จำเป็น? |
|------|-----------|--------|---------|
| `protocol` | Protocol ที่อนุญาต (tcp, udp, icmp) | string | Yes |
| `ports` | รายการ ports ที่อนุญาต | list(string) | Yes |
| `description` | คำอธิบายของ firewall rule | string | Yes |
| `src` | Source IP ranges ที่อนุญาต | list(string) | Yes |
| `dest` | Destination IP ranges (optional) | list(string) | No |

## 📤 ผลลัพธ์ (Outputs)

หลังจาก `terraform apply` สำเร็จ จะมีการแสดงผลลัพธ์ดังนี้:

| ชื่อ | คำอธิบาย |
|------|-----------|
| `subnet_map` | ข้อมูลของ Subnet ทั้งหมดที่ถูกสร้างขึ้น เช่น name, region, network, self_link |
| `vm_ips` | IP address (internal และ external) ของแต่ละ VM ที่ถูกสร้างขึ้น |
| `vm_details` | รายละเอียดของ VM ที่สร้างขึ้น รวมถึง IP address (internal และ external) |

## 🏗️ สถาปัตยกรรมที่สร้างขึ้น

โปรเจกต์นี้จะสร้างสถาปัตยกรรมพื้นฐานดังนี้:

1. **VPC Network**: เครือข่ายหลักสำหรับโปรเจกต์ (devops-network)
2. **Subnets**: เครือข่ายย่อย 3 โซน
   - `internet-facing` (192.168.1.0/24): สำหรับ services ที่เข้าถึงได้จาก internet
   - `private` (192.168.2.0/24): สำหรับ services ที่ไม่ต้องการ public access
   - `internal` (192.168.3.0/24): สำหรับ internal services และ management
3. **VM Instances**: เครื่องเสมือนตามบทบาทต่างๆ
   - Control node, HAProxy, Squid Proxy (internet-facing)
   - Kubernetes cluster (private)
   - Jenkins, ELK Stack (internal)
4. **Firewall Rules**: กฎการรักษาความปลอดภัยที่ครอบคลุม
   - SSH, HTTP, HTTPS access
   - Proxy และ Load Balancer rules
   - Kubernetes API และ NodePort access
   - Monitoring และ Logging traffic
5. **Service APIs**: การเปิดใช้งาน GCP Services ที่จำเป็น

## 🤝 การมีส่วนร่วม

หากต้องการมีส่วนร่วมในการพัฒนาโปรเจกต์:

1. Fork repository นี้
2. สร้าง feature branch (`git checkout -b feature/amazing-feature`)
3. Commit การเปลี่ยนแปลงของคุณ (`git commit -m 'Add some amazing feature'`)
4. Push ไปยัง branch (`git push origin feature/amazing-feature`)
5. เปิด Pull Request

## 📝 License

โปรเจกต์นี้เป็นโอเพนซอร์ส และสามารถใช้งานได้ภายใต้ใบอนุญาต MIT License

## 🔍 การแก้ไขปัญหา

### ปัญหาที่พบบ่อย

1. **Authentication Error**: 
   - ตรวจสอบว่าได้ทำการ `gcloud auth application-default login` แล้ว
   - หรือตรวจสอบ path ของ credentials file ใน `terraform.tfvars`

2. **Permission Denied**: 
   - ตรวจสอบว่าบัญชีของคุณมีสิทธิ์ที่เหมาะสมในโปรเจกต์ GCP
   - ตรวจสอบว่า Service Account มีสิทธิ์ Compute Admin, Network Admin

3. **API Not Enabled**: 
   - ตรวจสอบว่าได้เปิดใช้งาน API ที่จำเป็นในโปรเจกต์แล้ว
   - รัน `terraform apply` อีกครั้งหลังจาก API ถูกเปิดใช้งาน

4. **Firewall Rules Conflict**: 
   - ตรวจสอบว่า CIDR ranges ไม่ทับซ้อนกัน
   - ตรวจสอบว่า destination IP ตรงกับ VM ที่ต้องการ

5. **IP Forwarding Issues**: 
   - ตรวจสอบว่าได้ตั้งค่า `can_ip_forward = true` สำหรับ VM ที่ทำหน้าที่ proxy

### การดูข้อมูล State

```bash
# ดูสถานะปัจจุบันของ resources
terraform state list

# ดูรายละเอียดของ resource เฉพาะ
terraform state show <resource_name>
```

## 📞 ติดต่อ

หากมีข้อสงสัยหรือปัญหา สามารถเปิด Issue ใน GitHub repository นี้ได้

---

⭐ หากโปรเจกต์นี้มีประโยชน์กับคุณ อย่าลืมกด Star ให้ด้วยนะครับ!