
-## สิ่งที่ต้องมี (Prerequisites)
-
-1.  **Terraform**: ติดตั้ง Terraform (เวอร์ชัน 1.0.0 หรือสูงกว่า)
-2.  **Google Cloud SDK**: ติดตั้ง `gcloud` CLI และทำการยืนยันตัวตน
-3.  **GCP Project**: มีโปรเจกต์ GCP ที่พร้อมใช้งาน
-4.  **Service Account**: สร้าง Service Account และดาวน์โหลดไฟล์ Key ในรูปแบบ JSON (ในโปรเจกต์นี้คาดว่าจะมีไฟล์ชื่อ `terraform-trianning-a9fe9bf713a2.json` อยู่ในไดเรกทอรีเดียวกัน)
-
-## การใช้งาน (Usage)
-
-1.  **Clone a repository (ถ้ามี):**
+## 🚀 การเริ่มต้นใช้งาน (Getting Started)
+
+### สิ่งที่ต้องมี (Prerequisites)
+
+1.  **Terraform**: ติดตั้ง Terraform (เวอร์ชัน 1.2.0 หรือสูงกว่า)
+2.  **Google Cloud SDK**: ติดตั้ง `gcloud` CLI
+3.  **GCP Project**: มีโปรเจกต์ GCP ที่สร้างไว้แล้ว
+
+### 1. การยืนยันตัวตน (Authentication)
+
+แนะนำให้ใช้วิธี **Application Default Credentials (ADC)** ซึ่งปลอดภัยและสะดวกที่สุด
+
+```sh
+# ล็อกอินด้วยบัญชี Google ของคุณ
+gcloud auth login
+
+# สร้างไฟล์ credentials สำหรับให้แอปพลิเคชัน (เช่น Terraform) ใช้งาน
+gcloud auth application-default login
+```
+
+Terraform จะตรวจจับและใช้ credentials นี้โดยอัตโนมัติ
+
+### 2. การกำหนดค่าโปรเจกต์
+
+1.  **Clone a repository:**
    ```sh
    git clone <your-repository-url>
    cd infra
    ```

-2.  **กำหนดค่าตัวแปร:**
-    สร้างไฟล์ `terraform.tfvars` จากตัวอย่าง `terraform.tfvars.example` (หรือสร้างขึ้นมาใหม่) เพื่อกำหนดค่าที่จำเป็น
-
-    **ตัวอย่าง `terraform.tfvars`:**
+2.  **สร้างไฟล์ `terraform.tfvars`:**
+    คัดลอกไฟล์ `terraform.tfvars.example` มาเป็น `terraform.tfvars` และแก้ไขค่าตัวแปรให้ตรงกับสภาพแวดล้อมของคุณ
+
+    ```sh
+    cp terraform.tfvars.example terraform.tfvars
+    ```
+
+    **แก้ไขไฟล์ `terraform.tfvars`:**
    ```hcl
-    project_id = "your-gcp-project-id"
-    region     = "asia-southeast1"
+    # ID ของโปรเจกต์ GCP ของคุณ
+    project_id = "my-awesome-gcp-project"
+
+    # รายการ API ที่ต้องการเปิดใช้งาน
+    services = [
+      "compute.googleapis.com",
+      "iam.googleapis.com",
+      "cloudresourcemanager.googleapis.com",
+    ]

    instance_configs = {
      "web-server-01" = {
-        zone         = "asia-southeast1-a"
-        machine_type = "e2-micro"
+        zone             = "asia-southeast1-a"
+        machine_type     = "e2-micro"
        subnet           = "internet-facing"
-        assign_public_ip = true # ระบุให้มี Public IP
+        assign_public_ip = true              # ระบุให้มี Public IP
      },
      "app-server-01" = {
-        zone         = "asia-southeast1-b"
-        machine_type = "e2-small"
+        zone             = "asia-southeast1-b"
+        machine_type     = "e2-small"
        subnet           = "private"
-        # assign_public_ip จะเป็น false โดยอัตโนมัติ
+        # assign_public_ip จะเป็น false โดยอัตโนมัติ (ค่า default)
      }
    }
+
+    subnets_config = {
+      "internet-facing" = { cidr_range = "10.10.1.0/24" },
+      "private"         = { cidr_range = "10.10.2.0/24" }
+    }
    ```

-3.  **Deploy โครงสร้างพื้นฐาน:**
-    รันคำสั่ง Terraform ตามลำดับ
-
-    ```sh
-    # เริ่มต้นโปรเจกต์และดาวน์โหลด providers
-    terraform init
-
-    # (แนะนำ) ตรวจสอบแผนการทำงานก่อน apply
-    terraform plan
-
-    # สร้าง resources ทั้งหมด
-    terraform apply
-    ```
-
-4.  **ทำลาย Resources:**
-    หากต้องการลบ resources ทั้งหมดที่สร้างโดย Terraform ให้รันคำสั่ง:
-    ```sh
-    terraform destroy
-    ```
-
-## ตัวแปร (Inputs)
-
-| ชื่อ | คำอธิบาย | ประเภท | ค่าเริ่มต้น | จำเป็นต้องระบุ? |
-| --- | --- | --- | --- | :---: |
-| `project_id` | ID ของโปรเจกต์ GCP | `string` | - | Yes |
-| `region` | Region ของ GCP ที่จะสร้าง resources | `string` | `"asia-southeast1"` | No |
-| `instance_configs` | Map object สำหรับกำหนดค่า VM แต่ละเครื่อง (ดูตัวอย่างด้านบน) | `map(object)` | - | Yes |
-| `subnets_config` | Map object สำหรับกำหนดค่า Subnet แต่ละโซน | `map(object)` | มีค่า default 3 subnets | No |
-
-## ผลลัพธ์ (Outputs)
-
-หลังจาก `terraform apply` สำเร็จ จะมีการแสดงผลลัพธ์ดังนี้:
+### 3. การ Deploy และทำลาย
+
+```sh
+# 1. เริ่มต้นโปรเจกต์และดาวน์โหลด providers
+terraform init
+
+# 2. (แนะนำ) ตรวจสอบแผนการทำงานก่อน apply
+terraform plan
+
+# 3. สร้าง resources ทั้งหมด
+terraform apply
+
+# หากต้องการลบ resources ทั้งหมดที่สร้างโดย Terraform
+terraform destroy
+```
+
+## Terraform Reference
+
+### ตัวแปร (Inputs)
+
+| ชื่อ | คำอธิบาย | ประเภท | ค่าเริ่มต้น | จำเป็น? |
+| :--- | :--- | :--- | :--- | :---: |
+| `project_id` | ID ของโปรเจกต์ Google Cloud | `string` | - | **Yes** |
+| `services` | รายการ Service API ที่ต้องการเปิดใช้งาน | `list(string)` | - | **Yes** |
+| `instance_configs` | Map object สำหรับกำหนดค่า VM แต่ละเครื่อง | `map(object)` | - | **Yes** |
+| `subnets_config` | Map object สำหรับกำหนดค่า Subnet แต่ละโซน | `map(object)` | - | **Yes** |
+| `credentials` | Path ไปยังไฟล์ Service Account JSON key (ไม่แนะนำ) | `string` | `null` | No |
+| `region` | Region ของ GCP ที่จะสร้าง resources | `string` | `"asia-southeast1"` | No |
+| `network_name` | ชื่อของ VPC Network ที่จะสร้าง | `string` | `"devops-network"` | No |
+
+### ผลลัพธ์ (Outputs)

| ชื่อ | คำอธิบาย |
-| --- | --- |
+| :--- | :--- |
| `subnet_map` | ข้อมูลของ Subnet ทั้งหมดที่ถูกสร้างขึ้น เช่น `name`, `region`, `network`, `self_link` |
-| `vm_ips` | IP address (internal และ external) ของแต่ละ VM ที่ถูกสร้างขึ้น |
+| `vm_details` | รายละเอียดของ VM ที่สร้างขึ้น รวมถึง IP address (internal และ external) |

