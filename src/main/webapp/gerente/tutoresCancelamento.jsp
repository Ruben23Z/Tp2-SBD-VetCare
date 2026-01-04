<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% List<Map<String, Object>> dados = (List<Map<String, Object>>) request.getAttribute("dados"); %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Estatística de Cancelamentos - Sistema Veterinário</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --danger-color: #dc3545;
            --danger-light: #fff5f5;
            --warning-color: #ffc107;
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
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
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

        .warning-banner {
            background: linear-gradient(135deg, #fff3cd 0%, #fff3cd 100%);
            border-left: 4px solid var(--warning-color);
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            display: flex;
            align-items: start;
            gap: 12px;
        }

        .warning-banner i {
            color: #856404;
            font-size: 1.3rem;
            margin-top: 2px;
        }

        .warning-banner-text {
            flex: 1;
            color: #856404;
        }

        .warning-banner-text strong {
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
            background: linear-gradient(135deg, var(--danger-light) 0%, #ffe5e5 100%);
        }

        th {
            padding: 18px 15px;
            font-weight: 600;
            color: #b71c1c;
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
            background-color: #fff5f5;
            transform: scale(1.01);
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.1);
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
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--danger-light) 0%, #ffe5e5 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--danger-color);
            font-weight: 700;
            font-size: 1rem;
        }

        .tutor-name {
            font-weight: 600;
            color: #2d3748;
        }

        .ranking-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 30px;
            height: 30px;
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            border-radius: 50%;
            font-weight: 700;
            color: #856404;
            font-size: 0.85rem;
            margin-right: 10px;
        }

        .ranking-badge.top1 {
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.4);
        }

        .ranking-badge.top2 {
            background: linear-gradient(135deg, #c0c0c0 0%, #e8e8e8 100%);
            color: #495057;
        }

        .ranking-badge.top3 {
            background: linear-gradient(135deg, #cd7f32 0%, #e5a679 100%);
            color: #fff;
        }

        .cancel-count {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            border-radius: 20px;
            font-weight: 700;
            font-size: 1.1rem;
            box-shadow: 0 4px 10px rgba(220, 53, 69, 0.3);
        }

        .severity-indicator {
            display: inline-block;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            margin-left: 8px;
        }

        .severity-high { background: #dc3545; }
        .severity-medium { background: #ffc107; }
        .severity-low { background: #28a745; }

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

            .ranking-badge {
                margin-bottom: 5px;
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
                <i class="bi bi-x-circle"></i>
                Estatística de Cancelamentos
            </h2>
            <div class="subtitle">
                <i class="bi bi-calendar-x"></i>
                Tutores com maior número de cancelamentos no último trimestre
            </div>
            <% if (dados != null && !dados.isEmpty()) { %>
            <div class="stats-badge">
                <i class="bi bi-exclamation-triangle"></i>
                <span><%= dados.size() %> <%= dados.size() == 1 ? "tutor identificado" : "tutores identificados" %></span>
            </div>
            <% } %>
        </div>

        <div class="card-body-custom">
            <% if (dados == null || dados.isEmpty()) { %>
            <div class="empty-state">
                <i class="bi bi-check-circle"></i>
                <h4>Excelente notícia!</h4>
                <p>Não há registo de cancelamentos nos últimos 3 meses.</p>
            </div>
            <% } else {
                // Calcular o máximo para determinar severidade
                int maxCancel = 0;
                for(Map<String, Object> r : dados) {
                    int total = (Integer) r.get("totalCancelados");
                    if(total > maxCancel) maxCancel = total;
                }
            %>

            <div class="warning-banner">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <div class="warning-banner-text">
                    <strong>Atenção:</strong>
                    Esta lista apresenta os tutores com maior índice de cancelamentos.
                    Considere contactar estes tutores para compreender as razões e melhorar o serviço.
                </div>
            </div>

            <div class="table-container">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th><i class="bi bi-person me-2"></i>Nome do Tutor</th>
                        <th style="text-align: right;"><i class="bi bi-clipboard-x me-2"></i>Total de Cancelamentos</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        int rank = 1;
                        for(Map<String, Object> row : dados) {
                            int totalCancelados = (Integer) row.get("totalCancelados");
                            String nomeTutor = (String) row.get("nomeTutor");

                            // Determinar classe de ranking
                            String rankClass = "";
                            if(rank == 1) rankClass = "top1";
                            else if(rank == 2) rankClass = "top2";
                            else if(rank == 3) rankClass = "top3";

                            // Determinar severidade (baseado em percentagem do máximo)
                            String severity = "";
                            double percentage = (maxCancel > 0) ? ((double)totalCancelados / maxCancel) * 100 : 0;
                            if(percentage >= 70) severity = "severity-high";
                            else if(percentage >= 40) severity = "severity-medium";
                            else severity = "severity-low";

                            // Obter iniciais para avatar
                            String initials = "";
                            String[] parts = nomeTutor.split(" ");
                            if(parts.length > 0) initials += parts[0].charAt(0);
                            if(parts.length > 1) initials += parts[parts.length-1].charAt(0);
                    %>
                    <tr>
                        <td>
                            <div class="tutor-info">
                                <% if(rank <= 3) { %>
                                <span class="ranking-badge <%= rankClass %>"><%= rank %></span>
                                <% } %>
                                <div class="tutor-avatar"><%= initials.toUpperCase() %></div>
                                <span class="tutor-name"><%= nomeTutor %></span>
                            </div>
                        </td>
                        <td style="text-align: right;">
                                <span class="cancel-count">
                                    <i class="bi bi-exclamation-circle"></i>
                                    <%= totalCancelados %>
                                </span>
                            <span class="severity-indicator <%= severity %>"></span>
                        </td>
                    </tr>
                    <%
                            rank++;
                        }
                    %>
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