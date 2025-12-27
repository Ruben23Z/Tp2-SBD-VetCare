<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PetCare - Clínica Veterinária</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        @keyframes gradientShift {
            0% {
                background-position: 0% 50%;
            }
            50% {
                background-position: 100% 50%;
            }
            100% {
                background-position: 0% 50%;
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px) rotate(0deg);
            }
            50% {
                transform: translateY(-30px) rotate(5deg);
            }
        }

        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-100px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(100px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
        }

        @keyframes bounce {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-10px);
            }
        }

        @keyframes pawPrint {
            0% {
                opacity: 0;
                transform: scale(0) rotate(0deg);
            }
            50% {
                opacity: 0.15;
            }
            100% {
                opacity: 0;
                transform: scale(2) rotate(180deg);
            }
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(-45deg, #667eea, #764ba2, #f093fb, #4facfe);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            min-height: 100vh;
            overflow-x: hidden;
        }

        .paw-decoration {
            position: fixed;
            font-size: 120px;
            opacity: 0;
            pointer-events: none;
            z-index: 1;
        }

        .paw-1 {
            top: 10%;
            left: 5%;
            animation: pawPrint 8s ease-in-out infinite;
        }

        .paw-2 {
            top: 60%;
            right: 8%;
            animation: pawPrint 10s ease-in-out infinite 2s;
        }

        .paw-3 {
            bottom: 15%;
            left: 15%;
            animation: pawPrint 9s ease-in-out infinite 4s;
        }

        nav {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 20px 0;
            box-shadow: 0 5px 30px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
            animation: slideInRight 0.8s ease-out;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 32px;
            font-weight: 700;
            color: #667eea;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: float 3s ease-in-out infinite;
        }

        .logo-icon {
            font-size: 40px;
        }

        .nav-links {
            display: flex;
            gap: 30px;
            list-style: none;
        }

        .nav-links a {
            text-decoration: none;
            color: #333;
            font-weight: 600;
            transition: all 0.3s;
            position: relative;
            padding: 5px 0;
        }

        .nav-links a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 3px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            transition: width 0.3s;
            border-radius: 2px;
        }

        .nav-links a:hover {
            color: #667eea;
        }

        .nav-links a:hover::after {
            width: 100%;
        }

        .btn-login-nav {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-block;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-login-nav:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.5);
        }

        .hero {
            max-width: 1200px;
            margin: 80px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
        }

        .hero-content {
            animation: slideInLeft 1s ease-out;
        }

        .hero-content h1 {
            font-size: 56px;
            color: white;
            margin-bottom: 20px;
            text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
            line-height: 1.2;
        }

        .hero-content p {
            font-size: 20px;
            color: rgba(255, 255, 255, 0.95);
            margin-bottom: 40px;
            line-height: 1.6;
        }

        .hero-buttons {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .btn-primary, .btn-secondary {
            padding: 16px 40px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: 700;
            font-size: 16px;
            transition: all 0.3s;
            display: inline-block;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-primary {
            background: white;
            color: #667eea;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .btn-primary:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 2px solid white;
            backdrop-filter: blur(10px);
        }

        .btn-secondary:hover {
            background: white;
            color: #667eea;
            transform: translateY(-5px);
        }

        .hero-image {
            text-align: center;
            animation: slideInRight 1s ease-out;
        }

        .hero-image-icon {
            font-size: 300px;
            animation: float 4s ease-in-out infinite;
            filter: drop-shadow(0 20px 40px rgba(0, 0, 0, 0.3));
        }

        .features {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 80px 20px;
            margin-top: 60px;
        }

        .features-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .features-title {
            text-align: center;
            font-size: 42px;
            color: #333;
            margin-bottom: 60px;
            animation: fadeInUp 1s ease-out;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 40px;
        }

        .feature-card {
            background: white;
            padding: 40px 30px;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
            animation: fadeInUp 1s ease-out;
            animation-fill-mode: both;
        }

        .feature-card:nth-child(1) {
            animation-delay: 0.2s;
        }

        .feature-card:nth-child(2) {
            animation-delay: 0.4s;
        }

        .feature-card:nth-child(3) {
            animation-delay: 0.6s;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(102, 126, 234, 0.3);
        }

        .feature-icon {
            font-size: 64px;
            margin-bottom: 20px;
            animation: bounce 2s ease-in-out infinite;
        }

        .feature-card:nth-child(2) .feature-icon {
            animation-delay: 0.3s;
        }

        .feature-card:nth-child(3) .feature-icon {
            animation-delay: 0.6s;
        }

        .feature-card h3 {
            font-size: 24px;
            color: #333;
            margin-bottom: 15px;
        }

        .feature-card p {
            color: #666;
            line-height: 1.6;
            font-size: 15px;
        }

        .stats {
            max-width: 1200px;
            margin: 80px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 40px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 40px 20px;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            animation: fadeInUp 1s ease-out;
            transition: all 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-10px) scale(1.05);
        }

        .stat-number {
            font-size: 48px;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 10px;
            animation: pulse 2s ease-in-out infinite;
        }

        .stat-label {
            font-size: 16px;
            color: #666;
            font-weight: 600;
        }

        footer {
            background: rgba(51, 51, 51, 0.95);
            backdrop-filter: blur(10px);
            color: white;
            text-align: center;
            padding: 30px 20px;
            margin-top: 80px;
        }

        footer p {
            font-size: 14px;
            opacity: 0.9;
        }

        @media (max-width: 768px) {
            .hero {
                grid-template-columns: 1fr;
                text-align: center;
                gap: 40px;
            }

            .hero-content h1 {
                font-size: 38px;
            }

            .hero-image-icon {
                font-size: 200px;
            }

            .nav-links {
                display: none;
            }

            .hero-buttons {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
<div class="paw-decoration paw-1">🐾</div>
<div class="paw-decoration paw-2">🐾</div>
<div class="paw-decoration paw-3">🐾</div>

<nav>
    <div class="nav-container">
        <div class="logo">
            <span class="logo-icon">🐾</span>
            <span>PetCare</span>
        </div>
        <ul class="nav-links">
            <li><a href="#home">Início</a></li>
            <li><a href="#servicos">Serviços</a></li>
            <li><a href="#sobre">Sobre</a></li>
            <li><a href="#contato">Contato</a></li>
        </ul>
        <a href="login.jsp" class="btn-login-nav">Entrar</a>
    </div>
</nav>

<section class="hero" id="home">
    <div class="hero-content">
        <h1>Cuidando do Seu Pet com Amor</h1>
        <p>A melhor clínica veterinária da região. Atendimento especializado com profissionais dedicados ao bem-estar do
            seu melhor amigo.</p>
        <div class="hero-buttons">
            <a href="login.jsp" class="btn-primary">Agendar Consulta</a>
            <a href="#servicos" class="btn-secondary">Nossos Serviços</a>
        </div>
    </div>
    <div class="hero-image">
        <div class="hero-image-icon">🐕</div>
    </div>
</section>

<section class="stats">
    <div class="stat-card">
        <div class="stat-number">10K+</div>
        <div class="stat-label">Pets Atendidos</div>
    </div>
    <div class="stat-card">
        <div class="stat-number">15+</div>
        <div class="stat-label">Anos de Experiência</div>
    </div>
    <div class="stat-card">
        <div class="stat-number">98%</div>
        <div class="stat-label">Satisfação</div>
    </div>
    <div class="stat-card">
        <div class="stat-number">24/7</div>
        <div class="stat-label">Emergências</div>
    </div>
</section>

<section class="features" id="servicos">
    <div class="features-container">
        <h2 class="features-title">Nossos Serviços</h2>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">💉</div>
                <h3>Consultas</h3>
                <p>Atendimento clínico completo com veterinários especializados para cuidar da saúde do seu pet.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🏥</div>
                <h3>Cirurgias</h3>
                <p>Centro cirúrgico equipado com tecnologia de ponta para procedimentos seguros e eficientes.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🛁</div>
                <h3>Banho & Tosa</h3>
                <p>Serviços de estética e higiene com produtos de qualidade para deixar seu pet lindo e cheiroso.</p>
            </div>
        </div>
    </div>
</section>

<footer>
    <p>&copy; 2025 PetCare - Clínica Veterinária. Todos os direitos reservados.</p>
    <p>Cuidando dos seus pets com amor e dedicação ❤️🐾</p>
</footer>
</body>
</html>
