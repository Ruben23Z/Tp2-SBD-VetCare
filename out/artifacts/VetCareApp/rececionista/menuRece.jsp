<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    if (session == null || !"Rececionista".equals(session.getAttribute("cargo"))) {
        response.sendRedirect("../login.jsp?erro=3");
        return;
    }
    String utilizadorNome = ((model.Utilizador.Utilizador) session.getAttribute("utilizador")).getUsername();
%>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Painel Rececionista - VetCare</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        header {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px 40px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        header h1 {
            color: #2d3748;
            font-size: 28px;
            font-weight: 600;
        }

        .logout {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: #fff;
            padding: 12px 30px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(245, 87, 108, 0.3);
        }

        .logout:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(245, 87, 108, 0.4);
        }

        main {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #2d3748;
            font-size: 24px;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 3px solid #667eea;
        }

        .message {
            padding: 15px 25px;
            border-radius: 10px;
            margin-bottom: 30px;
            font-weight: 500;
            border-left: 4px solid;
            animation: slideIn 0.5s ease;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .message.success {
            background: #d4edda;
            color: #155724;
            border-left-color: #28a745;
        }

        .message.error {
            background: #f8d7da;
            color: #721c24;
            border-left-color: #dc3545;
        }

        .menu {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }

        .card {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border-radius: 12px;
            padding: 35px 25px;
            text-align: center;
            transition: all 0.3s ease;
            border: 2px solid transparent;
            position: relative;
            overflow: hidden;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .card:hover::before {
            transform: scaleX(1);
        }

        .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 40px rgba(102, 126, 234, 0.3);
            border-color: #667eea;
        }

        .card h3 {
            color: #2d3748;
            font-size: 22px;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .card p {
            color: #718096;
            font-size: 15px;
            line-height: 1.6;
            margin-bottom: 25px;
            min-height: 48px;
        }

        .card a {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            padding: 12px 28px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .card a:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        @media (max-width: 768px) {
            header {
                padding: 20px;
                text-align: center;
                justify-content: center;
            }

            header h1 {
                font-size: 22px;
            }

            main {
                padding: 25px 20px;
            }

            .menu {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <header>
        <h1>Bem-vindo, <%= utilizadorNome %>
        </h1>
        <a class="logout" href="${pageContext.request.contextPath}/logout.jsp">Terminar Sessão</a>
    </header>

    <main>
        <h2>Painel do Rececionista</h2>

        <%
            String ok = request.getParameter("ok");
            String erro = request.getParameter("erro");
            if ("1".equals(ok)) {
        %>
        <div class="message success">Ação realizada com sucesso.</div>
        <% } else if ("1".equals(erro)) { %>
        <div class="message error">Ocorreu um erro. Verifique os dados e tente novamente.</div>
        <% } %>

        <div class="menu">
            <div class="card">
                <h3>Clientes</h3>
                <p>Adicionar, atualizar ou remover clientes (Particulares/Empresas)</p>
                <a href="${pageContext.request.contextPath}/RececionistaServlet?action=gerirClientes">Gerir Clientes</a>
            </div>

            <div class="card">
                <h3>Animais</h3>
                <p>Adicionar, atualizar ou remover animais dos clientes</p>
                <a href="${pageContext.request.contextPath}/AnimalServlet?acao=listar">Gerir Animais</a>
            </div>

            <div class="card">
                <h3>Agendamento de Serviços</h3>
                <p>Agendar, cancelar ou reagendar serviços veterinários</p>
                <a href="${pageContext.request.contextPath}/AgendamentoServlet?action=novo">Agendar Serviços</a>
            </div>
        </div>
    </main>
</div>
</body>
</html>