project_id = "terraform-trianning"

credentials = "./terraform-trianning-a9fe9bf713a2.json"

instance_configs = {
    control     = { zone = "asia-southeast1-b", machine_type = "e2-small", subnet = "internet-facing" , assign_public_ip = true}
    haproxy     = { zone = "asia-southeast1-b", machine_type = "e2-small", subnet = "internet-facing" , can_ip_forward = true, assign_public_ip = true}
    squidproxy  = { zone = "asia-southeast1-b", machine_type = "e2-small", subnet = "internet-facing" , can_ip_forward = true, assign_public_ip = true}
    k8s         = { zone = "asia-southeast1-b", machine_type = "e2-medium", subnet = "private" }
    jenkins     = { zone = "asia-southeast1-b", machine_type = "e2-small", subnet = "internal" }
    elkstack    = { zone = "asia-southeast1-b", machine_type = "e2-medium", subnet = "internal" }
}

subnets_config = {
    "internet-facing" = { cidr_range = "192.168.1.0/24" }
    "private"         = { cidr_range = "192.168.2.0/24" }
    "internal"        = { cidr_range = "192.168.3.0/24" }
}

firewalls_config = {
    "devops-allow-ssh-http-https" = { protocol = "tcp", 
                                    ports = [ "22", "80", "443" ], 
                                    description = "Allow inbound SSH (22), HTTP (80), and HTTPS (443) traffic from any source.", 
                                    src = [ "0.0.0.0/0" ] 
                                    }
    "devops-privateinternal-sqiud" = { protocol = "tcp", 
                                    ports = [ "3128" ], 
                                    description = "Allow traffic from private (192.168.2.0/24) and internal (192.168.3.0/24) networks to the Squid proxy (192.168.1.3) on port 3128.", 
                                    src = [ "192.168.2.0/24", "192.168.3.0/24" ] 
                                    dest = ["192.168.1.3"]
                                    }
    "devops-internet-ha" = { protocol = "tcp", 
                                    ports = [ "5601", "8080", "30800-30805" ], 
                                    description = "Allow public internet access to HAProxy (192.168.1.4) for forwarded services on ports 5601, 8080, and 30800-30805.", 
                                    src = [ "0.0.0.0/0" ] 
                                    dest = ["192.168.1.4"]
                                    }
    "devops-ha-jenkins" = { protocol = "tcp", 
                                    ports = [ "8080" ], 
                                    description = "Allow traffic from any source to the Jenkins server (192.168.3.3) on port 8080.", 
                                    src = [ "0.0.0.0/0" ] 
                                    dest = ["192.168.3.3"]
                                    }
    "devops-ha-elk" = { protocol = "tcp", 
                                    ports = [ "5601" ], 
                                    description = "Allow traffic from any source to the ELK/Kibana instance (192.168.3.2) on port 5601.", 
                                    src = [ "0.0.0.0/0" ] 
                                    dest = ["192.168.3.2"]
                                    }
    "devops-internetprivate-elk" = { protocol = "tcp", 
                                    ports = [ "5044" ], 
                                    description = "Allow Logstash Beats input from the internet (192.168.1.0/24) and private (192.168.2.0/24) zones to the ELK server (192.168.3.2) on port 5044.", 
                                    src = [ "192.168.1.0/24", "192.168.2.0/24" ] 
                                    dest = ["192.168.3.2"]
                                    }
    "devops-private-internetinternal" = { protocol = "tcp", 
                                    ports = [ "9100" ], 
                                    description = "Allow Prometheus/Node Exporter metric scraping on port 9100 from the private zone (192.168.2.0/24) to the internal host 192.168.3.2 and the internet zone (192.168.1.0/24).", 
                                    src = [ "192.168.2.0/24" ] 
                                    dest = [ "192.168.3.2", "192.168.1.0/24" ]
                                    }
    "devops-internetinternal-private" = { protocol = "tcp", 
                                    ports = [ "6443", "30800-30805" ], 
                                    description = "Allow Kubernetes API (6443) and NodePort (30800-30805) access from the internet zone (192.168.1.0/24) and internal host 192.168.3.2 to the private zone (192.168.2.0/24).", 
                                    src = [ "192.168.3.2", "192.168.1.0/24" ] 
                                    dest = [ "192.168.2.0/24" ]
                                    } 

}

services = ["compute.googleapis.com", 
            "iam.googleapis.com", 
            "cloudresourcemanager.googleapis.com",]
