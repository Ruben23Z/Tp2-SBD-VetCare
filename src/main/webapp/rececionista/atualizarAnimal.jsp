<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Paciente.Paciente" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Animal - VetCare</title>
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
            max-width: 700px;
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

        .photo-section {
            background: #f8f9ff;
            padding: 20px;
            border-radius: 12px;
            border: 2px dashed #d0d7ff;
            text-align: center;
            margin-bottom: 20px;
        }

        .current-photo {
            margin: 15px 0;
        }

        .current-photo img {
            max-width: 200px;
            height: auto;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border: 3px solid #fff;
        }

        .photo-label {
            font-size: 14px;
            color: #667eea;
            font-weight: 600;
            margin-bottom: 10px;
        }

        input[type="file"] {
            padding: 10px;
            background: #fff;
            cursor: pointer;
        }

        input[type="file"]::file-selector-button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            margin-right: 10px;
        }

        input[type="file"]::file-selector-button:hover {
            opacity: 0.9;
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
<% Paciente p = (Paciente) request.getAttribute("animal"); %>

<div class="container">
    <div class="header">
        <div class="icon">🐾</div>
        <h2>Editar Informações do Animal</h2>
        <% if (p != null) { %>
        <p class="subtitle">Atualize os dados de <strong><%= p.getNome() %></strong></p>
        <% } %>
    </div>

    <% if (p != null) { %>
    <form action="${pageContext.request.contextPath}/AnimalServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="atualizar">
        <input type="hidden" name="idPaciente" value="<%= p.getidPaciente() %>">
        <input type="hidden" name="fotoAtual" value="<%= (p.getFoto() != null) ? p.getFoto() : "" %>">

        <div class="section-title">
            <span>📋</span> Informações Básicas
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Nome do Animal</label>
                <input type="text" name="nome" value="<%= p.getNome() %>" required placeholder="Ex: Max, Luna">
            </div>

            <div class="form-group">
                <label>NIF do Tutor</label>
                <input type="text" name="nif" value="<%= p.getNifDono() %>" required placeholder="123456789">
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Raça</label>
                <input type="text" name="raca" value="<%= p.getRaca() %>" required placeholder="Ex: Labrador, Pastor Alemão">
            </div>

            <div class="form-group">
                <label>Data de Nascimento</label>
                <input type="date" name="dataNascimento" value="<%= p.getDataNascimento() %>" required>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Peso Atual (kg)</label>
                <input type="number" step="0.1" name="peso" value="<%= p.getPesoAtual() %>" required placeholder="Ex: 12.5">
            </div>

            <div class="form-group">
                <label>Sexo</label>
                <select name="sexo" required>
                    <option value="M" <%= "M".equals(p.getSexo()) ? "selected" : "" %>>🐕 Macho</option>
                    <option value="F" <%= "F".equals(p.getSexo()) ? "selected" : "" %>>🐕 Fêmea</option>
                </select>
            </div>
        </div>

        <div class="section-title">
            <span>📸</span> Fotografia
        </div>

        <div class="photo-section">
            <% if(p.getFoto() != null && !p.getFoto().isEmpty()) { %>
            <div class="photo-label">Foto atual do animal:</div>
            <div class="current-photo">
                <img src="${pageContext.request.contextPath}/<%= p.getFoto() %>" alt="<%= p.getNome() %>">
            </div>
            <% } else { %>
            <div class="photo-label">Nenhuma foto disponível</div>
            <% } %>

            <div class="form-group" style="margin-top: 15px;">
                <label>Alterar Fotografia <span class="info-badge">Opcional</span></label>
                <input type="file" name="foto" accept="image/*">
            </div>
        </div>

        <div class="button-group">
            <a href="${pageContext.request.contextPath}/AnimalServlet?action=listar" class="btn btn-cancel">
                Cancelar
            </a>
            <button type="submit">
                Atualizar Animal
            </button>
        </div>
    </form>
    <% } else { %>
    <div class="error-box">
        <div style="font-size: 48px; margin-bottom: 10px;">⚠️</div>
        <h3 style="margin-bottom: 10px;">Erro: Animal não encontrado</h3>
        <p>O animal que está a tentar editar não existe ou não foi possível carregar os seus dados.</p>
        <div style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/AnimalServlet?action=listar" class="btn btn-cancel" style="display: inline-block; width: auto;">
                ← Voltar à lista
            </a>
        </div>
    </div>
    <% } %>
</div>
</body>
</html>