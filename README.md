# Azure Active Directory Lab

## Overview
This project is a walkthorugh on how to set up an Active Directory lab in Microsoft Azure. The lab simulates a real-world environment with two domain controllers on the same domain, all hosted in the cloud—ideal for users whose home PCs can't handle local virtualization. It's a great way to practice and improve Active Directory skills using only RDP and HTTPS to connect. After setup, users are encouraged to explore real-world scenarios such as managing user accounts, setting permissions, and configuring group policies.

## Prerequisites 
 - Mircosoft Azure
 - Windows Remote Desktop Connection
   
## Network Topology

- **Domain Controller (DC1):** Windows Server 2019 Datacenter
- **Domain Controller (DC2):** Windows Server 2019 Datacenter
- **Network Range:** 10.0.0.0/22
- **Domain:** mydazurelab.com

## Project Objectives
- Deploy and configure two **Windows Server VMs**
- Set up **Active Directory Domain Services (ADDS)**
- Set up and manage **DNS services** and **custom IP configurations**
- Add **150 users and 5 Organizational Units (OUs)** via PowerShell
- Authenticate users and verify **network connectivity**
- Implement **security policies** for domain users

# Active Directory Deployment & PowerShell Automation 🤖
## 📺 Watch the Video:
<div>
    <a href="https://www.loom.com/share/dfc7bab6d55b4f9a954a11c9e1fff671">
      <p>Creating an Active Directory Lab in Microsoft Azure Cloud Services</p>
    </a>
    <a href="https://www.loom.com/share/dfc7bab6d55b4f9a954a11c9e1fff671">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/dfc7bab6d55b4f9a954a11c9e1fff671-b5cfe3c126c74c16-full-play.gif">
    </a>
  </div>
 
 ---
 
 
## Creating an Active Directory Lab in Microsoft Azure

**Step 1: Create a Resource Group** [0:14](https://loom.com/share/dfc7bab6d55b4f9a954a11c9e1fff671?t=14)

- Navigate to Azure Portal.
- Click on 'Create a resource group'.
- Name the resource group 'ADLAB'.
- Review and create the resource group.

**Step 2: Create a Virtual Network** [0:50](https://loom.com/share/dfc7bab6d55b4f9a954a11c9e1fff671?t=50)

- In the Azure Portal, select 'Virtual networks'.
- Click 'Create'.
- Name the virtual network 'onsite'.
- Set the address space to '10.0.0.0/22'.
- Create the first subnet named 'external' with starting address '10.0.1.0' and range from '10.0.1.1' to '10.0.1.127'.
- Click 'Create'.
- Add another subnet named 'internal'.
- Set the address range starting from '10.0.1.128'.

**Step 3: Create Domain Controller 1** [4:11](https://loom.com/share/dfc7bab6d55b4f9a954a11c9e1fff671?t=251)

- Click on 'Create a virtual machine'.
- Select the resource group 'ADLAB'.
- Name the VM 'DC1'.
- Create an availability set for redundancy.
- Choose 'Windows Server 2019 Datacenter' as the image.
- Set size to 2 virtual CPUs and 8 GB RAM.
- Set username to 'JDoe' and use a secure password.
- Enable Remote Desktop access.

**Step 4: Configure Disk and Networking** [5:38](https://loom.com/share/dfc7bab6d55b4f9a954a11c9e1fff671?t=338)

- Set the disk type to 'Standard HDD' with 10 GB.
- Attach the disk for Active Directory lab.
- Set the subnet to 'external'
- Review all settings and click 'Create'.
- Wait for the deployment to succeed.

**Step 5: Configure Network Interface for Internal** [8:35](https://loom.com/share/dfc7bab6d55b4f9a954a11c9e1fff671?t=515)

- Stop the VM if running.
- Attach a new network interface for the internal subnet.
- Set it to dynamic IP initially, then change to static.
- Download the RDP file and open it with Microsoft Remote Desktop.
- Connect to the VM.

**Step 6: Install Active Directory Role** [15:32](https://loom.com/share/dfc7bab6d55b4f9a954a11c9e1fff671?t=932)

- Open Server Manager.
- Select 'Add Roles and Features'.
- Follow the prompts to install Active Directory.

**Step 7: Promote Domain Controller 1** [21:28](https://loom.com/share/dfc7bab6d55b4f9a954a11c9e1fff671?t=1288)

- After installation, promote the server to a domain controller.
- Set the domain name to 'myazurelab.com'.
- Use a secure password and complete the promotion.
- In the 'OnSite' Virtual Network, set Custom DNS servers and paste the IP for DC1.
- Restart DC1

**Step 8: Create Domain Controller 2** [22:36](https://loom.com/share/dfc7bab6d55b4f9a954a11c9e1fff671?t=1356)

- Repeat the process to create a second virtual machine named 'DC2'.
- Use the same configurations as DC1.
- Attach the internal network interface.
- Start the VM and connect via RDP.

**Step 9: Add Domain Controller 2 to Domain** [32:49](https://loom.com/share/dfc7bab6d55b4f9a954a11c9e1fff671?t=1969)

- Use DC1 credentials to add DC2 to the domain.
  - Restart DC2 after adding.
- Add Active Directory Domain Services on DC2 and promote it to a domain controller replicating from DC1.
- Check if users and settings are replicated between DC1 and DC2.
- In 'OnSite' Virtual Network, add DC2's IP as a secondary DNS server.
  - Restart DC1 and DC2 to Update DNS

**Step 10: Add Users via Script** [45:06](https://loom.com/share/dfc7bab6d55b4f9a954a11c9e1fff671?t=2706)
- Within DC1, use 'Active Directory Sites and Services' to add the subnets and assign them to the 'OnSite' site
  - Rename Default site to “Onsite”
- Use PowerShell to run a script that adds multiple users to the domain.

### Cautionary Notes

- Ensure that all configurations are double-checked before proceeding to the next step.
- Be cautious with IP address assignments to avoid conflicts.

### Tips for Efficiency

- Use templates for virtual machines to speed up the creation process.
- Document any changes made during the setup for future reference.
