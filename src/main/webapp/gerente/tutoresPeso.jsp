<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% List<Map<String, Object>> dados = (List<Map<String, Object>>) request.getAttribute("dados"); %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Estatística de Peso - Sistema Veterinário</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --pink-color: #e91e63;
            --pink-light: #fce4ec;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .main-container {
            max-width: 900px;
            margin: 0 auto;
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

        .card-custom {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            overflow: hidden;
        }

        .card-header-custom {
            background: linear-gradient(135deg, #e91e63 0%, #c2185b 100%);
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
            margin-top: 10px;
            font-size: 0.95rem;
            opacity: 0.95;
            display: flex;
            align-items: center;
            gap: 8px;
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

        .card-body-custom {
            padding: 35px;
        }

        .info-banner {
            background: linear-gradient(135deg, var(--pink-light) 0%, #f8bbd0 100%);
            border-left: 4px solid var(--pink-color);
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            display: flex;
            align-items: start;
            gap: 12px;
        }

        .info-banner i {
            color: #c2185b;
            font-size: 1.3rem;
            margin-top: 2px;
        }

        .info-banner-text {
            flex: 1;
            color: #880e4f;
        }

        .info-banner-text strong {
            display: block;
            margin-bottom: 3px;
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
            background-color: var(--pink-light);
            transform: scale(1.01);
            box-shadow: 0 2px 8px rgba(233, 30, 99, 0.1);
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .tutor-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .tutor-avatar {
            width: 45px;
            height: 45px;
            background: linear-gradient(135deg, var(--pink-light) 0%, #f8bbd0 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--pink-color);
            font-weight: 700;
            font-size: 1rem;
            border: 2px solid var(--pink-color);
        }

        .tutor-name {
            font-weight: 600;
            color: #2d3748;
        }

        .count-badge-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .count-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 18px;
            background: linear-gradient(135deg, #e91e63 0%, #c2185b 100%);
            color: white;
            border-radius: 25px;
            font-weight: 700;
            font-size: 1.1rem;
            box-shadow: 0 4px 15px rgba(233, 30, 99, 0.3);
            min-width: 60px;
            justify-content: center;
        }

        .severity-indicator {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }

        .severity-high {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }

        .severity-medium {
            background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
            color: white;
        }

        .severity-low {
            background: linear-gradient(135deg, #28a745 0%, #218838 100%);
            color: white;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }

        .empty-state i {
            font-size: 4rem;
            color: #d4edda;
            margin-bottom: 20px;
        }

        .empty-state h4 {
            color: #28a745;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #6c757d;
        }

        .stats-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, var(--pink-light) 0%, #f8bbd0 100%);
            padding: 20px;
            border-radius: 12px;
            border-left: 4px solid var(--pink-color);
        }

        .stat-label {
            font-size: 0.85rem;
            color: #880e4f;
            font-weight: 600;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #c2185b;
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

            .tutor-info {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }

            .count-badge-wrapper {
                flex-direction: column;
                gap: 8px;
            }

            .stats-summary {
                grid-template-columns: 1fr;
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
                <i class="bi bi-speedometer2"></i>
                Monitorização de Peso dos Animais
            </h2>
            <div class="subtitle">
                <i class="bi bi-exclamation-diamond"></i>
                Tutores com animais acima do peso ideal da raça
            </div>
            <% if (dados != null && !dados.isEmpty()) { %>
            <div class="stats-badge">
                <i class="bi bi-people"></i>
                <span><%= dados.size() %> <%= dados.size() == 1 ? "tutor identificado" : "tutores identificados" %></span>
            </div>
            <% } %>
        </div>

        <div class="card-body-custom">
            <% if (dados == null || dados.isEmpty()) { %>
            <div class="empty-state">
                <i class="bi bi-check-circle"></i>
                <h4>Excelente resultado!</h4>
                <p>Não foram encontrados animais com peso acima da média da raça.</p>
            </div>
            <% } else {
                // Calcular estatísticas
                int totalAnimais = 0;
                int maxAnimais = 0;
                for(Map<String, Object> r : dados) {
                    int qtd = (Integer) r.get("qtdAnimais");
                    totalAnimais += qtd;
                    if(qtd > maxAnimais) maxAnimais = qtd;
                }
            %>

            <div class="stats-summary">
                <div class="stat-card">
                    <div class="stat-label">
                        <i class="bi bi-people"></i>
                        Tutores Afetados
                    </div>
                    <div class="stat-value"><%= dados.size() %></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">
                        <i class="bi bi-heart-pulse"></i>
                        Total de Animais
                    </div>
                    <div class="stat-value"><%= totalAnimais %></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">
                        <i class="bi bi-exclamation-triangle"></i>
                        Máximo por Tutor
                    </div>
                    <div class="stat-value"><%= maxAnimais %></div>
                </div>
            </div>

            <div class="info-banner">
                <i class="bi bi-info-circle-fill"></i>
                <div class="info-banner-text">
                    <strong>Informação importante:</strong>
                    Esta lista apresenta tutores cujos animais ultrapassam o peso médio ideal para a raça.
                    Recomenda-se consulta veterinária e plano nutricional adequado. Lista ordenada alfabeticamente.
                </div>
            </div>

            <div class="table-container">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th><i class="bi bi-person me-2"></i>Nome do Tutor</th>
                        <th style="text-align: center;"><i class="bi bi-clipboard-data me-2"></i>Animais com Excesso de Peso</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for(Map<String, Object> row : dados) {
                        int qtdAnimais = (Integer) row.get("qtdAnimais");
                        String nomeTutor = (String) row.get("nomeTutor");

                        // Determinar severidade
                        String severity = "";
                        String severityIcon = "";
                        if(qtdAnimais >= 4) {
                            severity = "severity-high";
                            severityIcon = "bi-exclamation-octagon-fill";
                        } else if(qtdAnimais >= 2) {
                            severity = "severity-medium";
                            severityIcon = "bi-exclamation-triangle-fill";
                        } else {
                            severity = "severity-low";
                            severityIcon = "bi-exclamation-circle-fill";
                        }

                        // Obter iniciais para avatar
                        String initials = "";
                        String[] parts = nomeTutor.split(" ");
                        if(parts.length > 0) initials += parts[0].charAt(0);
                        if(parts.length > 1) initials += parts[parts.length-1].charAt(0);
                    %>
                    <tr>
                        <td>
                            <div class="tutor-info">
                                <div class="tutor-avatar"><%= initials.toUpperCase() %></div>
                                <span class="tutor-name"><%= nomeTutor %></span>
                            </div>
                        </td>
                        <td style="text-align: center;">
                            <div class="count-badge-wrapper">
                                    <span class="count-badge">
                                        <i class="bi bi-heart-pulse"></i>
                                        <%= qtdAnimais %>
                                    </span>
                                <div class="severity-indicator <%= severity %>">
                                    <i class="bi <%= severityIcon %>"></i>
                                </div>
                            </div>
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