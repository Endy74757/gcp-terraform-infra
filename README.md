# โครงสร้างพื้นฐาน GCP ด้วย Terraform

[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/)

โปรเจกต์นี้ใช้ Terraform เพื่อสร้างและจัดการโครงสร้างพื้นฐานหลัก (Core Infrastructure) บน Google Cloud Platform (GCP) อย่างเป็นระบบและอัตโนมัติ ถูกออกแบบในรูปแบบโมดูลเพื่อให้ง่ายต่อการจัดการ, นำไปใช้ซ้ำ, และขยายความสามารถในอนาคต

## ✨ คุณสมบัติหลัก (Key Features)

*   **การจัดการ API อัตโนมัติ**: เปิดใช้งาน Service API ที่จำเป็นสำหรับโปรเจกต์โดยอัตโนมัติ
*   **เครือข่ายที่ยืดหยุ่น**: สร้าง VPC Network และ Subnets ได้ตามที่กำหนดในไฟล์คอนฟิก
*   **การสร้าง VM แบบไดนามิก**: สร้าง VM instances หลายเครื่องพร้อมกัน โดยแต่ละเครื่องสามารถมี configuration (zone, machine type, public IP) ที่แตกต่างกันได้
*   **การติดแท็กอัตโนมัติ**: VM แต่ละเครื่องจะถูกติดแท็ก (Tag) ด้วยชื่อของ Subnet ที่ตัวเองอยู่ (`internet-facing`, `private`, etc.) เพื่อให้ง่ายต่อการกำหนด Firewall Rules

## 📂 โครงสร้างโปรเจกต์

```
gcp-terraform-infra/
├── compute/                # โมดูลสำหรับจัดการ VM instances
├── network/                # โมดูลสำหรับจัดการ VPC และ Subnets
├── Service/                # โมดูลสำหรับจัดการการเปิดใช้งาน API
├── .gitignore
├── main.tf                 # ไฟล์หลักที่เรียกใช้โมดูลทั้งหมด
├── variables.tf            # ตัวแปรหลักของโปรเจกต์
├── output.tf               # ผลลัพธ์หลักของโปรเจกต์
├── provider.tf             # กำหนดค่า GCP provider
├── terraform.tfvars.example  # ตัวอย่างไฟล์กำหนดค่าตัวแปร
└── README.md
```

## 🚀 การเริ่มต้นใช้งาน (Getting Started)

### สิ่งที่ต้องมี (Prerequisites)

1.  **Terraform**: ติดตั้ง Terraform (เวอร์ชัน 1.2.0 หรือสูงกว่า)
2.  **Google Cloud SDK**: ติดตั้ง `gcloud` CLI
3.  **GCP Project**: มีโปรเจกต์ GCP ที่พร้อมใช้งาน

### 1. การยืนยันตัวตน (Authentication)

เราแนะนำให้ใช้วิธี **Application Default Credentials (ADC)** ซึ่งปลอดภัยและสะดวกที่สุด

```sh
# ล็อกอินด้วยบัญชี Google ของคุณ
gcloud auth login

# สร้างไฟล์ credentials สำหรับให้แอปพลิเคชัน (เช่น Terraform) ตรวจจับและใช้งานโดยอัตโนมัติ
gcloud auth application-default login
```

Terraform จะตรวจจับและใช้ credentials นี้โดยอัตโนมัติ

### 2. การกำหนดค่าโปรเจกต์

1.  **Clone a repository:**
    ```sh
    git clone <your-repository-url>
    cd infra
    ```

2.  **กำหนดค่าตัวแปร:**
    สร้างไฟล์ `terraform.tfvars` จากตัวอย่าง `terraform.tfvars.example` (หรือสร้างขึ้นมาใหม่) เพื่อกำหนดค่าที่จำเป็น

    **ตัวอย่าง `terraform.tfvars`:**
3.  **สร้างไฟล์ `terraform.tfvars`:**
    คัดลอกไฟล์ `terraform.tfvars.example` มาเป็น `terraform.tfvars` และแก้ไขค่าตัวแปรให้ตรงกับสภาพแวดล้อมของคุณ

    ```sh
    cp terraform.tfvars.example terraform.tfvars
    ```

    **แก้ไขไฟล์ `terraform.tfvars`:**
    ```hcl
    project_id = "your-gcp-project-id"
    region     = "asia-southeast1"
    # ID ของโปรเจกต์ GCP ของคุณ
    project_id = "my-awesome-gcp-project"
    
    # service account ของโปรเจกต์ GCP ของคุณ
    credentials = "Path/To/svc-account-key.json"


    # รายการ API ที่ต้องการเปิดใช้งาน
    services = [
      "compute.googleapis.com",
      "iam.googleapis.com",
      "cloudresourcemanager.googleapis.com",
    ]

    instance_configs = {
      "web-server-01" = {
        zone         = "asia-southeast1-a"
        machine_type = "e2-micro"
        zone             = "asia-southeast1-a"
        machine_type     = "e2-micro"
        subnet           = "internet-facing"
        assign_public_ip = true # ระบุให้มี Public IP
        assign_public_ip = true              # ระบุให้มี Public IP
      },
      "app-server-01" = {
        zone         = "asia-southeast1-b"
        machine_type = "e2-small"
        zone             = "asia-southeast1-b"
        machine_type     = "e2-small"
        subnet           = "private"
        # assign_public_ip จะเป็น false โดยอัตโนมัติ
        # assign_public_ip จะเป็น false โดยอัตโนมัติ (ค่า default)
      }
    }

    subnets_config = {
      "internet-facing" = { cidr_range = "10.10.1.0/24" },
      "private"         = { cidr_range = "10.10.2.0/24" }
    }
    ```

4.  **Deploy โครงสร้างพื้นฐาน:**
    รันคำสั่ง Terraform ตามลำดับ

    ```sh
    # เริ่มต้นโปรเจกต์และดาวน์โหลด providers
    terraform init

    # (แนะนำ) ตรวจสอบแผนการทำงานก่อน apply
    terraform plan

    # สร้าง resources ทั้งหมด
    terraform apply
    ```

5.  **ทำลาย Resources:**
    หากต้องการลบ resources ทั้งหมดที่สร้างโดย Terraform ให้รันคำสั่ง:
    ```sh
    terraform destroy
    ```

## ตัวแปร (Inputs)

| ชื่อ | คำอธิบาย | ประเภท | ค่าเริ่มต้น | จำเป็นต้องระบุ? |
| --- | --- | --- | --- | :---: |
| `project_id` | ID ของโปรเจกต์ GCP | `string` | - | Yes |
| `region` | Region ของ GCP ที่จะสร้าง resources | `string` | `"asia-southeast1"` | No |
| `instance_configs` | Map object สำหรับกำหนดค่า VM แต่ละเครื่อง (ดูตัวอย่างด้านบน) | `map(object)` | - | Yes |
| `subnets_config` | Map object สำหรับกำหนดค่า Subnet แต่ละโซน | `map(object)` | มีค่า default 3 subnets | No |

## ผลลัพธ์ (Outputs)

หลังจาก `terraform apply` สำเร็จ จะมีการแสดงผลลัพธ์ดังนี้:
### 3. การ Deploy และทำลาย

```sh
# 1. เริ่มต้นโปรเจกต์และดาวน์โหลด providers
terraform init

# 2. (แนะนำ) ตรวจสอบแผนการทำงานก่อน apply
terraform plan

# 3. สร้าง resources ทั้งหมด
terraform apply

# หากต้องการลบ resources ทั้งหมดที่สร้างโดย Terraform
terraform destroy
```

## Terraform Reference

### ตัวแปร (Inputs)

| ชื่อ | คำอธิบาย | ประเภท | ค่าเริ่มต้น | จำเป็น? |
| :--- | :--- | :--- | :--- | :---: |
| `project_id` | ID ของโปรเจกต์ Google Cloud | `string` | - | **Yes** |
| `services` | รายการ Service API ที่ต้องการเปิดใช้งาน | `list(string)` | - | **Yes** |
| `instance_configs` | Map object สำหรับกำหนดค่า VM แต่ละเครื่อง | `map(object)` | - | **Yes** |
| `subnets_config` | Map object สำหรับกำหนดค่า Subnet แต่ละโซน | `map(object)` | - | **Yes** |
| `credentials` | Path ไปยังไฟล์ Service Account JSON key | `string` | `null` | No |
| `region` | Region ของ GCP ที่จะสร้าง resources | `string` | `"asia-southeast1"` | No |
| `network_name` | ชื่อของ VPC Network ที่จะสร้าง | `string` | `"devops-network"` | No |
### ผลลัพธ์ (Outputs)

| ชื่อ | คำอธิบาย |
| --- | --- |
| :--- | :--- |
| `subnet_map` | ข้อมูลของ Subnet ทั้งหมดที่ถูกสร้างขึ้น เช่น `name`, `region`, `network`, `self_link` |
| `vm_ips` | IP address (internal และ external) ของแต่ละ VM ที่ถูกสร้างขึ้น |
| `vm_details` | รายละเอียดของ VM ที่สร้างขึ้น รวมถึง IP address (internal และ external) |
