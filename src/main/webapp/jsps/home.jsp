<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>DEVOPS Albert | Cloud Automation & Engineering Portfolio</title>
    <link href="images/devops.png" rel="icon">
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f9;
            color: #333;
            text-align: center;
            padding: 30px;
        }
        h1, h2 {
            color: #2c3e50;
        }
        hr {
            border: 0;
            height: 2px;
            background: #3498db;
            margin: 30px 0;
        }
        .footer {
            margin-top: 40px;
            font-size: 14px;
            color: #777;
        }
        a {
            color: #3498db;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
        .server-info {
            background: #fff;
            display: inline-block;
            padding: 15px 25px;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            margin-top: 20px;
        }
        .contact-section {
            margin-top: 25px;
        }
        .social-links a {
            margin: 0 10px;
            color: #333;
            font-weight: bold;
        }
        .social-links a:hover {
            color: #3498db;
        }
    </style>
</head>
<body>
    <h1>🚀 Welcome to <span style="color:#3498db;">DEVOPS Albert</span></h1>
    <h2>Building Scalable, Automated, and Cloud-Native Solutions</h2>
    <p>
        I’m <strong>Albert</strong>, a passionate <strong>DevOps Engineer</strong> focused on creating reliable, automated CI/CD pipelines, 
        containerized applications, and cloud infrastructure.  
        This web application demonstrates a complete CI/CD pipeline — deployed automatically from Jenkins to Tomcat on AWS.
    </p>

    <hr>

    <div class="server-info">
        <h3>Server Environment Details</h3>
        <%
            InetAddress inetAddress = InetAddress.getLocalHost();
            String ip = inetAddress.getHostAddress();
            out.println("Server Host Name: " + inetAddress.getHostName() + "<br>");
            out.println("Server IP Address: " + ip + "<br>");
        %>
    </div>

    <hr>

    <div class="contact-section">
        <img src="images/devops.png" alt="DevOps Logo" width="120"><br><br>
        <p><strong>DEVOPS Albert</strong><br>
        Cloud & DevOps Engineer<br>
        AWS | Jenkins | Docker |GitHub Actions | Terraform | Kubernetes | CI/CD Automation<br>
        📍 Accra, Ghana<br>
        📧 <a href="mailto:albertarko3@gmail.com">albertarko3@gmail.com</a></p>
    </div>

    <div class="social-links">
        🌐 <a href="https://www.linkedin.com/in/albert-paintsil-arko" target="_blank">LinkedIn</a> |
        💻 <a href="https://github.com/AAPaintsil24" target="_blank">GitHub</a>
    </div>

    <hr>

    <p>🔍 Service Endpoint: <a href="services/employee/getEmployeeDetails">Get Employee Details</a></p>

    <div class="footer">
        <p>✅ Deployed via Jenkins CI/CD Pipeline on AWS EC2 with Apache Tomcat</p>
        <p>© 2025 by <strong>DEVOPS Albert</strong>. All Rights Reserved.</p>
    </div>
</body>
</html>

