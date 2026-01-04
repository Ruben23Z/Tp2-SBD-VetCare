<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% List<Map<String, Object>> dados = (List<Map<String, Object>>) request.getAttribute("dados"); %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Previsão Semanal - Sistema Veterinário</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --blue-color: #2196F3;
            --blue-light: #e3f2fd;
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
            background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%);
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

        .card-body-custom {
            padding: 35px;
        }

        .info-banner {
            background: linear-gradient(135deg, var(--blue-light) 0%, #bbdefb 100%);
            border-left: 4px solid var(--blue-color);
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            display: flex;
            align-items: start;
            gap: 12px;
        }

        .info-banner i {
            color: var(--blue-color);
            font-size: 1.3rem;
            margin-top: 2px;
        }

        .info-banner-text {
            flex: 1;
            color: #0d47a1;
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
            background: linear-gradient(135deg, var(--blue-light) 0%, #bbdefb 100%);
        }

        th {
            padding: 18px 15px;
            font-weight: 600;
            color: #0d47a1;
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

        .service-name {
            font-weight: 600;
            color: #2d3748;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .service-icon {
            width: 35px;
            height: 35px;
            background: linear-gradient(135deg, var(--blue-light) 0%, #bbdefb 100%);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--blue-color);
        }

        .quantity-cell {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .quantity-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 50px;
            padding: 6px 14px;
            background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%);
            color: white;
            border-radius: 20px;
            font-weight: 700;
            font-size: 1rem;
        }

        .bar-container {
            flex: 1;
            height: 24px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 12px;
            position: relative;
            overflow: hidden;
            box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .bar {
            height: 100%;
            background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%);
            border-radius: 12px;
            transition: width 0.8s ease;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding-right: 10px;
            color: white;
            font-size: 0.75rem;
            font-weight: 600;
            min-width: 30px;
        }

        .bar::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            animation: shimmer 2s infinite;
        }

        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
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

        .stats-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, var(--blue-light) 0%, #bbdefb 100%);
            padding: 20px;
            border-radius: 12px;
            border-left: 4px solid var(--blue-color);
        }

        .stat-label {
            font-size: 0.85rem;
            color: #0d47a1;
            font-weight: 600;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #1976D2;
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

            .quantity-cell {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .bar-container {
                width: 100%;
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
                <i class="bi bi-calendar-week"></i>
                Previsão Semanal de Agendamentos
            </h2>
            <div class="subtitle">
                <i class="bi bi-clock-history"></i>
                Análise dos serviços previstos para os próximos 7 dias
            </div>
        </div>

        <div class="card-body-custom">
            <% if (dados == null || dados.isEmpty()) { %>
            <div class="empty-state">
                <i class="bi bi-calendar-x"></i>
                <h4>Sem agendamentos previstos</h4>
                <p>Não há serviços agendados para a próxima semana.</p>
            </div>
            <% } else {
                // Calcular estatísticas
                int max = 0;
                int total = 0;
                for(Map<String, Object> r : dados) {
                    int qtd = (Integer) r.get("qtd");
                    total += qtd;
                    if(qtd > max) max = qtd;
                }
                int numServicos = dados.size();
            %>

            <div class="stats-summary">
                <div class="stat-card">
                    <div class="stat-label">
                        <i class="bi bi-calendar-check"></i>
                        Total de Agendamentos
                    </div>
                    <div class="stat-value"><%= total %></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">
                        <i class="bi bi-list-check"></i>
                        Tipos de Serviço
                    </div>
                    <div class="stat-value"><%= numServicos %></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">
                        <i class="bi bi-graph-up"></i>
                        Serviço Mais Procurado
                    </div>
                    <div class="stat-value"><%= max %></div>
                </div>
            </div>

            <div class="info-banner">
                <i class="bi bi-info-circle-fill"></i>
                <div class="info-banner-text">
                    <strong>Informação:</strong>
                    Previsão baseada em agendamentos ativos e pendentes confirmados para os próximos 7 dias.
                    As barras representam a proporção de cada serviço em relação ao mais solicitado.
                </div>
            </div>

            <div class="table-container">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th><i class="bi bi-tag me-2"></i>Tipo de Serviço</th>
                        <th><i class="bi bi-bar-chart me-2"></i>Quantidade Prevista</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for(Map<String, Object> row : dados) {
                        int qtd = (Integer) row.get("qtd");
                        int width = (max > 0) ? (qtd * 100) / max : 0;
                        String tipo = (String) row.get("tipo");

                        // Escolher ícone baseado no tipo de serviço
                        String icon = "clipboard-pulse";
                        if(tipo.toLowerCase().contains("consulta")) icon = "stethoscope";
                        else if(tipo.toLowerCase().contains("vacina")) icon = "shield-plus";
                        else if(tipo.toLowerCase().contains("cirurgia")) icon = "hospital";
                        else if(tipo.toLowerCase().contains("exame")) icon = "file-medical";
                    %>
                    <tr>
                        <td>
                            <div class="service-name">
                                <div class="service-icon">
                                    <i class="bi bi-<%= icon %>"></i>
                                </div>
                                <strong><%= tipo %></strong>
                            </div>
                        </td>
                        <td>
                            <div class="quantity-cell">
                                <span class="quantity-badge"><%= qtd %></span>
                                <div class="bar-container">
                                    <div class="bar" style="width: <%= width %>%;"></div>
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