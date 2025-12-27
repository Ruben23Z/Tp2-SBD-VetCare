<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Clínica Veterinária PetCare</title>
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

        @keyframes float {
            0%, 100% {
                transform: translateY(0px);
            }
            50% {
                transform: translateY(-20px);
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes shake {
            0%, 100% {
                transform: translateX(0);
            }
            25% {
                transform: translateX(-10px);
            }
            75% {
                transform: translateX(10px);
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

        @keyframes pawPrint {
            0% {
                opacity: 0;
                transform: scale(0) rotate(0deg);
            }
            50% {
                opacity: 0.3;
            }
            100% {
                opacity: 0;
                transform: scale(1.5) rotate(180deg);
            }
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(-45deg, #667eea, #764ba2, #f093fb, #4facfe);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }

        body::before {
            content: '🐾';
            position: absolute;
            font-size: 100px;
            opacity: 0;
            animation: pawPrint 4s ease-in-out infinite;
            top: 20%;
            left: 10%;
        }

        body::after {
            content: '🐾';
            position: absolute;
            font-size: 80px;
            opacity: 0;
            animation: pawPrint 5s ease-in-out infinite 2s;
            bottom: 30%;
            right: 15%;
        }

        .paw-bg {
            position: absolute;
            font-size: 60px;
            opacity: 0;
            animation: pawPrint 6s ease-in-out infinite 1s;
            top: 60%;
            left: 70%;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 30px;
            box-shadow: 0 30px 80px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            width: 100%;
            max-width: 450px;
            animation: fadeInUp 0.6s ease-out;
            position: relative;
        }

        .login-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            padding: 50px 30px;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .login-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            animation: pulse 3s ease-in-out infinite;
        }

        .login-icon {
            font-size: 80px;
            margin-bottom: 15px;
            animation: float 3s ease-in-out infinite;
            display: inline-block;
            position: relative;
            z-index: 1;
        }

        .login-header h1 {
            font-size: 32px;
            margin-bottom: 10px;
            font-weight: 700;
            position: relative;
            z-index: 1;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
        }

        .login-header p {
            font-size: 16px;
            opacity: 0.95;
            position: relative;
            z-index: 1;
        }

        .login-form {
            padding: 45px 35px;
        }

        .form-group {
            margin-bottom: 28px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
            transition: color 0.3s;
        }

        .input-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 18px;
            color: #999;
            transition: color 0.3s;
        }

        .form-group input {
            width: 100%;
            padding: 14px 15px 14px 45px;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: white;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        .form-group input:focus + .input-icon {
            color: #667eea;
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
            font-size: 13px;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: color 0.3s;
        }

        .remember-me:hover {
            color: #667eea;
        }

        .remember-me input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #667eea;
        }

        .forgot-password {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            position: relative;
        }

        .forgot-password::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: #667eea;
            transition: width 0.3s;
        }

        .forgot-password:hover::after {
            width: 100%;
        }

        .btn-login {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 17px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-login::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.5s;
        }

        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.5);
        }

        .btn-login:hover::before {
            left: 100%;
        }

        .btn-login:active {
            transform: translateY(-1px);
        }

        .error-message {
            background: linear-gradient(135deg, #ff6b6b, #ee5a6f);
            color: white;
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-size: 14px;
            text-align: center;
            animation: shake 0.5s;
            box-shadow: 0 5px 15px rgba(255, 107, 107, 0.3);
            font-weight: 600;
        }

        .register-link {
            text-align: center;
            margin-top: 30px;
            font-size: 14px;
            color: #666;
        }

        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 700;
            transition: all 0.3s;
            position: relative;
        }

        .register-link a::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: #667eea;
            transition: width 0.3s;
        }

        .register-link a:hover {
            color: #764ba2;
        }

        .register-link a:hover::after {
            width: 100%;
        }

        .decorative-circle {
            position: absolute;
            border-radius: 50%;
            background: rgba(102, 126, 234, 0.1);
            animation: pulse 4s ease-in-out infinite;
        }

        .circle-1 {
            width: 100px;
            height: 100px;
            top: -50px;
            right: -50px;
        }

        .circle-2 {
            width: 150px;
            height: 150px;
            bottom: -75px;
            left: -75px;
            animation-delay: 1s;
        }
    </style>
</head>
<body>
<div class="paw-bg">🐾</div>

<div class="login-container">
    <div class="decorative-circle circle-1"></div>
    <div class="decorative-circle circle-2"></div>

    <div class="login-header">
        <div class="login-icon">🐾</div>
        <h1>PetCare</h1>
        <p>Clínica Veterinária - Cuidando com Amor</p>
    </div>

    <div class="login-form">
        <%
            String erro = request.getParameter("erro");
            if (erro != null && erro.equals("1")) {
        %>
        <div class="error-message">
            ⚠️ Usuário ou senha inválidos!
        </div>
        <% } %>

        <form action="validarLogin.jsp" method="post">
            <div class="form-group">
                <label for="usuario">Usuário</label>
                <div class="input-wrapper">
                    <input
                            type="text"
                            id="usuario"
                            name="usuario"
                            placeholder="Digite seu usuário"
                            required
                            autocomplete="username"
                    >
                    <span class="input-icon">👤</span>
                </div>
            </div>

            <div class="form-group">
                <label for="senha">Senha</label>
                <div class="input-wrapper">
                    <input
                            type="password"
                            id="senha"
                            name="senha"
                            placeholder="Digite sua senha"
                            required
                            autocomplete="current-password"
                    >
                    <span class="input-icon">🔒</span>
                </div>
            </div>

            <div class="form-options">
                <label class="remember-me">
                    <input type="checkbox" name="lembrar" value="true">
                    Lembrar-me
                </label>
                <a href="recuperarSenha.jsp" class="forgot-password">Esqueceu a senha?</a>
            </div>

            <button type="submit" class="btn-login">Entrar</button>
        </form>

        <div class="register-link">
            Não tem uma conta? <a href="registro.jsp">Cadastre-se agora</a>
        </div>
    </div>
</div>
</body>
</html>