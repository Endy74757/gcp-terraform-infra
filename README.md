# โครงสร้างพื้นฐาน GCP ด้วย Terraform

โปรเจกต์ Terraform นี้ใช้สำหรับสร้างและจัดการโครงสร้างพื้นฐานบน Google Cloud Platform (GCP) โดยอัตโนมัติ ประกอบด้วย:

*   **Service Activation**: เปิดใช้งาน Compute Engine API ที่จำเป็น
*   **Networking**: สร้าง Virtual Private Cloud (VPC) network และ Subnets ที่กำหนดเอง
*   **Compute**: สร้าง Virtual Machine (VM) instances ตามการกำหนดค่าที่ระบุ

โปรเจกต์นี้ถูกออกแบบมาในรูปแบบโมดูลเพื่อให้ง่ายต่อการจัดการและนำไปใช้ซ้ำ

## โครงสร้างโปรเจกต์

```
infra/
├── compute/              # โมดูลสำหรับจัดการ VM instances
│   ├── main.tf
│   ├── variables.tf
│   └── output.tf
├── network/              # โมดูลสำหรับจัดการ VPC และ Subnets
│   ├── main.tf
│   ├── variables.tf
│   └── output.tf
├── Service/              # โมดูลสำหรับจัดการการเปิดใช้งาน API
│   ├── main.tf
│   └── variables.tf
├── main.tf               # ไฟล์หลักที่เรียกใช้โมดูลทั้งหมด
├── variables.tf          # ตัวแปรหลักของโปรเจกต์
├── output.tf             # ผลลัพธ์หลักของโปรเจกต์
├── provider.tf           # กำหนดค่า GCP provider
└── terraform.tfvars.example # ตัวอย่างไฟล์กำหนดค่าตัวแปร
```

## สิ่งที่ต้องมี (Prerequisites)

1.  **Terraform**: ติดตั้ง Terraform (เวอร์ชัน 1.0.0 หรือสูงกว่า)
2.  **Google Cloud SDK**: ติดตั้ง `gcloud` CLI และทำการยืนยันตัวตน
3.  **GCP Project**: มีโปรเจกต์ GCP ที่พร้อมใช้งาน
4.  **Service Account**: สร้าง Service Account และดาวน์โหลดไฟล์ Key ในรูปแบบ JSON (ในโปรเจกต์นี้คาดว่าจะมีไฟล์ชื่อ `terraform-trianning-a9fe9bf713a2.json` อยู่ในไดเรกทอรีเดียวกัน)

## การใช้งาน (Usage)

1.  **Clone a repository (ถ้ามี):**
    ```sh
    git clone <your-repository-url>
    cd infra
    ```

2.  **กำหนดค่าตัวแปร:**
    สร้างไฟล์ `terraform.tfvars` จากตัวอย่าง `terraform.tfvars.example` (หรือสร้างขึ้นมาใหม่) เพื่อกำหนดค่าที่จำเป็น

    **ตัวอย่าง `terraform.tfvars`:**
    ```hcl
    project_id = "your-gcp-project-id"
    region     = "asia-southeast1"

    instance_configs = {
      "web-server-01" = {
        zone         = "asia-southeast1-a"
        machine_type = "e2-micro"
        subnet           = "internet-facing"
        assign_public_ip = true # ระบุให้มี Public IP
      },
      "app-server-01" = {
        zone         = "asia-southeast1-b"
        machine_type = "e2-small"
        subnet           = "private"
        # assign_public_ip จะเป็น false โดยอัตโนมัติ
      }
    }
    ```

3.  **Deploy โครงสร้างพื้นฐาน:**
    รันคำสั่ง Terraform ตามลำดับ

    ```sh
    # เริ่มต้นโปรเจกต์และดาวน์โหลด providers
    terraform init

    # (แนะนำ) ตรวจสอบแผนการทำงานก่อน apply
    terraform plan

    # สร้าง resources ทั้งหมด
    terraform apply
    ```

4.  **ทำลาย Resources:**
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

| ชื่อ | คำอธิบาย |
| --- | --- |
| `subnet_map` | ข้อมูลของ Subnet ทั้งหมดที่ถูกสร้างขึ้น เช่น `name`, `region`, `network`, `self_link` |
| `vm_ips` | IP address (internal และ external) ของแต่ละ VM ที่ถูกสร้างขึ้น |