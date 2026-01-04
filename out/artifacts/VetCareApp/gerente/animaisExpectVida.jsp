<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% List<Map<String, Object>> dados = (List<Map<String, Object>>) request.getAttribute("dados"); %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Estatística de Longevidade - Sistema Veterinário</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --bg-light: #f8f9fa;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .main-container {
            max-width: 1100px;
            margin: 0 auto;
        }

        .card-custom {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            overflow: hidden;
        }

        .card-header-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 30px;
            border: none;
        }

        .card-header-custom h2 {
            margin: 0;
            font-size: 1.75rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .card-header-custom .subtitle {
            margin-top: 8px;
            font-size: 0.95rem;
            opacity: 0.95;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: white;
            text-decoration: none;
            background: rgba(255, 255, 255, 0.2);
            padding: 10px 20px;
            border-radius: 8px;
            transition: all 0.3s ease;
            margin-bottom: 20px;
            backdrop-filter: blur(10px);
        }

        .back-button:hover {
            background: rgba(255, 255, 255, 0.3);
            color: white;
            transform: translateX(-5px);
        }

        .card-body-custom {
            padding: 35px;
        }

        .table-container {
            overflow-x: auto;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        table {
            margin: 0;
            width: 100%;
        }

        thead {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        }

        th {
            padding: 18px 15px;
            font-weight: 600;
            color: #495057;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            border: none;
        }

        td {
            padding: 16px 15px;
            color: #495057;
            border-bottom: 1px solid #f1f3f5;
            vertical-align: middle;
        }

        tbody tr {
            transition: all 0.2s ease;
        }

        tbody tr:hover {
            background-color: #f8f9fa;
            transform: scale(1.01);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .animal-name {
            font-weight: 600;
            color: #2d3748;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .badge-custom {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .badge-success-custom {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }

        .badge-info {
            background: #e3f2fd;
            color: #1976d2;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }

        .empty-state i {
            font-size: 4rem;
            color: #dee2e6;
            margin-bottom: 20px;
        }

        .empty-state h4 {
            color: #6c757d;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #adb5bd;
        }

        .stats-badge {
            background: rgba(255, 255, 255, 0.2);
            padding: 8px 16px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 15px;
            backdrop-filter: blur(10px);
        }

        @media (max-width: 768px) {
            .card-header-custom h2 {
                font-size: 1.4rem;
            }

            .card-body-custom {
                padding: 20px;
            }

            th, td {
                padding: 12px 10px;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
<div class="main-container">
    <a href="GerenteServlet?action=dashboard" class="back-button">
        <i class="bi bi-arrow-left"></i>
        <span>Voltar ao Dashboard</span>
    </a>

    <div class="card-custom">
        <div class="card-header-custom">
            <h2>
                <i class="bi bi-graph-up-arrow"></i>
                Estatística de Longevidade
            </h2>
            <div class="subtitle">
                <i class="bi bi-info-circle"></i>
                Animais que superaram a expectativa de vida da sua espécie
            </div>
            <% if (dados != null && !dados.isEmpty()) { %>
            <div class="stats-badge">
                <i class="bi bi-check-circle-fill"></i>
                <span><%= dados.size() %> <%= dados.size() == 1 ? "animal identificado" : "animais identificados" %></span>
            </div>
            <% } %>
        </div>

        <div class="card-body-custom">
            <% if (dados == null || dados.isEmpty()) { %>
            <div class="empty-state">
                <i class="bi bi-inbox"></i>
                <h4>Nenhum registo encontrado</h4>
                <p>Não há registos de animais que tenham ultrapassado a esperança média de vida da espécie.</p>
            </div>
            <% } else { %>
            <div class="table-container">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th><i class="bi bi-tag me-2"></i>Nome do Animal</th>
                        <th><i class="bi bi-palette me-2"></i>Raça</th>
                        <th><i class="bi bi-calendar-event me-2"></i>Idade Atual</th>
                        <th><i class="bi bi-bar-chart me-2"></i>Esperança Média</th>
                        <th><i class="bi bi-trophy me-2"></i>Longevidade Extra</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for(Map<String, Object> row : dados) { %>
                    <tr>
                        <td>
                            <div class="animal-name">
                                <i class="bi bi-heart-pulse text-danger"></i>
                                <strong><%= row.get("nome") %></strong>
                            </div>
                        </td>
                        <td><%= row.get("raca") %></td>
                        <td>
                                <span class="badge-custom badge-info">
                                    <%= row.get("idade") %> anos
                                </span>
                        </td>
                        <td><%= row.get("expectVida") %> anos</td>
                        <td>
                                <span class="badge-custom badge-success-custom">
                                    <i class="bi bi-plus-circle"></i>
                                    <%= row.get("diferenca") %> anos
                                </span>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>