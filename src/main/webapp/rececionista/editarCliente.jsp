<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ClienteDAO" %>
<%@ page import="model.Utilizador.Cliente" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Cliente - VetCare</title>
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
            max-width: 800px;
            margin: 0 auto;
            background: #fff;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header .icon {
            font-size: 48px;
            margin-bottom: 10px;
        }

        .header h2 {
            color: #667eea;
            font-size: 28px;
            margin-bottom: 5px;
        }

        .header .subtitle {
            color: #666;
            font-size: 14px;
        }

        .section-title {
            color: #667eea;
            font-size: 18px;
            margin: 25px 0 15px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }

        input, select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: #f9f9f9;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        input:hover, select:hover {
            border-color: #b8c5f2;
        }

        .required-badge {
            color: #ff4444;
            font-size: 12px;
            font-weight: 600;
        }

        .info-badge {
            display: inline-block;
            background: #e8f0fe;
            color: #667eea;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            margin-left: 8px;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        button, .btn {
            flex: 1;
            padding: 15px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        button[type="submit"] {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        button[type="submit"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-cancel {
            background: #f0f0f0;
            color: #666;
        }

        .btn-cancel:hover {
            background: #e0e0e0;
            transform: translateY(-2px);
        }

        .error-box {
            background: #ffe6e6;
            border-left: 4px solid #ff4444;
            padding: 20px;
            border-radius: 8px;
            color: #cc0000;
            text-align: center;
            margin: 20px 0;
        }

        .client-info-box {
            background: #f0f4ff;
            border-left: 4px solid #667eea;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .client-info-box strong {
            color: #667eea;
        }

        @media (max-width: 600px) {
            .container {
                padding: 25px;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .button-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
<%
    Cliente c = null;
    String errorMessage = null;
    try {
        int id = Integer.parseInt(request.getParameter("idUtilizador"));
        c = new ClienteDAO().findById(id);
    } catch (Exception e) {
        errorMessage = "Erro ao carregar dados do cliente: " + e.getMessage();
    }
%>

<div class="container">
    <div class="header">
        <div class="icon">👤</div>
        <h2>Editar Informações do Cliente</h2>
        <% if (c != null) { %>
        <p class="subtitle">Atualize os dados de <strong><%= c.getNome() %></strong></p>
        <% } %>
    </div>

    <% if (errorMessage != null) { %>
    <div class="error-box">
        <div style="font-size: 48px; margin-bottom: 10px;">⚠️</div>
        <h3 style="margin-bottom: 10px;">Erro ao Carregar Cliente</h3>
        <p><%= errorMessage %></p>
        <div style="margin-top: 20px;">
            <a href="<%= request.getContextPath() %>/RececionistaServlet?action=listarClientes" class="btn btn-cancel" style="display: inline-block; width: auto;">
                ← Voltar à lista
            </a>
        </div>
    </div>
    <% } else if (c != null) { %>

    <div class="client-info-box">
        <strong>ID do Utilizador:</strong> <%= c.getiDUtilizador() %>
    </div>

    <form action="<%= request.getContextPath() %>/RececionistaServlet" method="post">
        <input type="hidden" name="action" value="atualizarCliente">
        <input type="hidden" name="idUtilizador" value="<%= c.getiDUtilizador() %>">

        <div class="section-title">
            <span>📝</span> Dados Pessoais
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Nome Completo <span class="required-badge">*</span></label>
                <input type="text" name="nomeCliente" value="<%= c.getNome() %>" required placeholder="Nome completo do cliente">
            </div>

            <div class="form-group">
                <label>NIF <span class="required-badge">*</span></label>
                <input type="text" name="nif" value="<%= c.getNIF() %>" required pattern="\d{9}" title="9 dígitos" placeholder="123456789">
            </div>
        </div>

        <div class="section-title">
            <span>📧</span> Contactos
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Email <span class="required-badge">*</span></label>
                <input type="email" name="email" value="<%= c.getEmail() %>" required placeholder="exemplo@email.com">
            </div>

            <div class="form-group">
                <label>Telefone <span class="info-badge">Opcional</span></label>
                <input type="text" name="telefone" value="<%= (c.getTelefone() != null) ? c.getTelefone() : "" %>" placeholder="+351 912345678">
            </div>
        </div>

        <div class="section-title">
            <span>🏠</span> Morada
        </div>

        <div class="form-group full-width">
            <label>Rua <span class="info-badge">Opcional</span></label>
            <input type="text" name="rua" value="<%= (c.getRua() != null) ? c.getRua() : "" %>" placeholder="Rua e número">
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>País <span class="info-badge">Opcional</span></label>
                <input type="text" name="pais" value="<%= (c.getPais() != null) ? c.getPais() : "" %>" placeholder="Portugal">
            </div>

            <div class="form-group">
                <label>Distrito <span class="info-badge">Opcional</span></label>
                <input type="text" name="distrito" value="<%= (c.getDistrito() != null) ? c.getDistrito() : "" %>" placeholder="Ex: Lisboa, Porto">
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Concelho <span class="info-badge">Opcional</span></label>
                <input type="text" name="concelho" value="<%= (c.getConcelho() != null) ? c.getConcelho() : "" %>" placeholder="Ex: Sintra, Matosinhos">
            </div>

            <div class="form-group">
                <label>Freguesia <span class="info-badge">Opcional</span></label>
                <input type="text" name="freguesia" value="<%= (c.getFreguesia() != null) ? c.getFreguesia() : "" %>" placeholder="Ex: São João">
            </div>
        </div>

        <div class="button-group">
            <a href="<%= request.getContextPath() %>/RececionistaServlet?action=listarClientes" class="btn btn-cancel">
                Cancelar
            </a>
            <button type="submit">
                Guardar Alterações
            </button>
        </div>
    </form>
    <% } else { %>
    <div class="error-box">
        <div style="font-size: 48px; margin-bottom: 10px;">⚠️</div>
        <h3 style="margin-bottom: 10px;">Cliente não encontrado</h3>
        <p>O cliente que está a tentar editar não existe ou não foi possível carregar os seus dados.</p>
        <div style="margin-top: 20px;">
            <a href="<%= request.getContextPath() %>/RececionistaServlet?action=listarClientes" class="btn btn-cancel" style="display: inline-block; width: auto;">
                ← Voltar à lista
            </a>
        </div>
    </div>
    <% } %>
</div>
</body>
</html>