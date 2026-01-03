<%@ page import="java.util.List" %>
<%@ page import="model.Paciente.Paciente" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Paciente> animais = (List<Paciente>) request.getAttribute("meusAnimais");
%>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Os Meus Animais | VetCare</title>
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

        .page-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .header-content {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header-icon {
            font-size: 48px;
            animation: bounce 2s ease-in-out infinite;
        }

        @keyframes bounce {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-10px);
            }
        }

        .header-text h1 {
            color: #2d3748;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .header-text p {
            color: #718096;
            font-size: 15px;
        }

        .btn-logout {
            background: linear-gradient(135deg, #fc8181 0%, #f56565 100%);
            color: white;
            padding: 12px 24px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(245, 101, 101, 0.3);
        }

        .btn-logout:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(245, 101, 101, 0.4);
        }

        .stats-banner {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .stats-banner .stat-number {
            font-size: 48px;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stats-banner .stat-label {
            color: #718096;
            font-size: 16px;
            margin-top: 5px;
        }

        .empty-state {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 80px 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .empty-state-icon {
            font-size: 96px;
            margin-bottom: 20px;
            opacity: 0.6;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px);
            }
            50% {
                transform: translateY(-20px);
            }
        }

        .empty-state h2 {
            color: #2d3748;
            font-size: 24px;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #718096;
            font-size: 16px;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }

        .pet-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px 25px;
            text-align: center;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .pet-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .pet-card:hover::before {
            transform: scaleX(1);
        }

        .pet-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.3);
        }

        .pet-icon {
            font-size: 72px;
            margin-bottom: 15px;
            display: inline-block;
            transition: transform 0.3s ease;
        }

        .pet-card:hover .pet-icon {
            transform: scale(1.1) rotate(5deg);
        }

        .pet-card h3 {
            color: #2d3748;
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .pet-info {
            background: #f7fafc;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .pet-detail {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .pet-detail:last-child {
            border-bottom: none;
        }

        .pet-detail-label {
            color: #718096;
            font-size: 13px;
            font-weight: 600;
        }

        .pet-detail-value {
            color: #2d3748;
            font-size: 13px;
            font-weight: 600;
        }

        .age-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            background: linear-gradient(135deg, #feebc8 0%, #fbd38d 100%);
            color: #7c2d12;
        }

        .btn-view {
            display: inline-block;
            width: 100%;
            padding: 14px 24px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-view:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .status-indicator {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #48bb78;
            box-shadow: 0 0 10px rgba(72, 187, 120, 0.6);
        }

        @media (max-width: 768px) {
            .header {
                padding: 20px;
            }

            .header-text h1 {
                font-size: 24px;
            }

            .header-icon {
                font-size: 36px;
            }

            .grid {
                grid-template-columns: 1fr;
            }

            .empty-state {
                padding: 60px 30px;
            }

            .empty-state-icon {
                font-size: 72px;
            }
        }

        @media (max-width: 480px) {
            .header-content {
                flex-direction: column;
                text-align: center;
            }

            .btn-logout {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>

<div class="page-container">
    <div class="header">
        <div class="header-content">
            <div class="header-icon">🐾</div>
            <div class="header-text">
                <h1> Os Meus Animaizinhos</h1>
                <p>Gerencie os cuidados veterinários dos seus companheiros</p>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout.jsp" class="btn-logout">
            Terminar Sessão
        </a>
    </div>

    <% if (animais != null && !animais.isEmpty()) { %>

    <div class="stats-banner">
        <div class="stat-number"><%= animais.size() %>
        </div>
        <div class="stat-label">
            <%= animais.size() == 1 ? "Animal Registado" : "Animais Registados" %>
        </div>
    </div>

    <div class="grid">
        <% for (Paciente p : animais) { %>
        <div class="pet-card">
            <div class="status-indicator" title="Animal ativo"></div>
            <div class="pet-icon">🐶</div>
            <h3><%= p.getNome() %>
            </h3>

            <div class="pet-info">
                <div class="pet-detail">
                    <span class="pet-detail-label">Raça</span>
                    <span class="pet-detail-value"><%= p.getRaca() %></span>
                </div>
                <div class="pet-detail">
                    <span class="pet-detail-label">Idade</span>
                    <span class="pet-detail-value">
                        <span class="age-badge"><%= p.getIdadeFormatada() %></span>
                    </span>
                </div>
                <div class="pet-detail">
                    <span class="pet-detail-label">Escalão</span>
                    <span class="pet-detail-value"><%= p.getEscalaoEtario() %></span>
                </div>
            </div>

            <a href="TutorServlet?action=verFicha&idPaciente=<%= p.getidPaciente() %>" class="btn-view">
                Ver Ficha Completa
            </a>
        </div>
        <% } %>
    </div>

    <% } else { %>

    <div class="empty-state">
        <div class="empty-state-icon">🐕</div>
        <h2>Ainda não tem animais registados</h2>
        <p>Entre em contacto com a receção para registar o seu primeiro companheiro.</p>
    </div>

    <% } %>
</div>

</body>
</html>