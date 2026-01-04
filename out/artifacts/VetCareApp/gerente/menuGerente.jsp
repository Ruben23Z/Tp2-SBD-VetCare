<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Painel de Gestão - Sistema Veterinário</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --info-color: #17a2b8;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .main-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 35px;
            background: rgba(255, 255, 255, 0.15);
            padding: 25px 30px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
        }

        .header-title {
            color: white;
            margin: 0;
            font-size: 2rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header-subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 0.95rem;
            margin-top: 5px;
        }

        .btn-logout {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: rgba(220, 53, 69, 0.9);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        .btn-logout:hover {
            background: rgba(220, 53, 69, 1);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(220, 53, 69, 0.4);
        }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
        }

        .section-header {
            grid-column: 1 / -1;
            background: rgba(255, 255, 255, 0.95);
            padding: 18px 25px;
            border-radius: 12px;
            margin-top: 15px;
            margin-bottom: 5px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .section-header h2 {
            margin: 0;
            font-size: 1.3rem;
            font-weight: 600;
            color: #2d3748;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-header .section-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
        }

        .menu-card {
            background: white;
            padding: 30px 25px;
            border-radius: 15px;
            text-align: center;
            text-decoration: none;
            color: #2d3748;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
        }

        .menu-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .menu-card:hover::before {
            transform: scaleX(1);
        }

        .menu-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(102, 126, 234, 0.3);
            color: #2d3748;
        }

        .menu-card-icon {
            width: 70px;
            height: 70px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            transition: all 0.3s ease;
        }

        .menu-card:hover .menu-card-icon {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            transform: scale(1.1) rotate(5deg);
        }

        .menu-card h3 {
            color: #2d3748;
            margin-bottom: 10px;
            font-size: 1.2rem;
            font-weight: 600;
        }

        .menu-card p {
            color: #6c757d;
            margin: 0;
            font-size: 0.9rem;
            line-height: 1.5;
        }

        .card-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: var(--info-color);
            color: white;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.7rem;
            font-weight: 600;
        }

        /* Cores específicas para diferentes categorias */
        .menu-card.personal .menu-card-icon i {
            color: #667eea;
        }

        .menu-card.operations .menu-card-icon i {
            color: #28a745;
        }

        .menu-card.statistics .menu-card-icon i {
            color: #17a2b8;
        }

        @media (max-width: 768px) {
            body {
                padding: 20px 10px;
            }

            .header-section {
                flex-direction: column;
                gap: 15px;
                text-align: center;
                padding: 20px;
            }

            .header-title {
                font-size: 1.5rem;
            }

            .menu-grid {
                grid-template-columns: 1fr;
            }

            .section-header {
                padding: 15px 20px;
            }

            .section-header h2 {
                font-size: 1.1rem;
            }

            .menu-card {
                padding: 25px 20px;
            }
        }
    </style>
</head>
<body>
<div class="main-container">
    <div class="header-section">
        <div>
            <h1 class="header-title">
                <i class="bi bi-building"></i>
                Painel de Gestão
            </h1>
            <div class="header-subtitle">
                <i class="bi bi-person-circle"></i>
                Sistema de Gestão Veterinária - Administração
            </div>
        </div>
        <a href="../logout.jsp" class="btn-logout">
            <i class="bi bi-box-arrow-right"></i>
            <span>Terminar Sessão</span>
        </a>
    </div>

    <div class="menu-grid">
        <!-- Seção: Gestão de Pessoal -->
        <div class="section-header">
            <h2>
                <div class="section-icon">
                    <i class="bi bi-people"></i>
                </div>
                <span>Gestão de Pessoal e Entidades</span>
            </h2>
        </div>

        <a href="${pageContext.request.contextPath}/GerenteServlet?action=listarVets" class="menu-card personal">
            <div class="menu-card-icon">
                <i class="bi bi-heart-pulse"></i>
            </div>
            <h3>Veterinários</h3>
            <p>Criar, editar e gerir perfis de veterinários do sistema</p>
        </a>

        <a href="${pageContext.request.contextPath}/GerenteServlet?action=gerirTutores" class="menu-card personal">
            <div class="menu-card-icon">
                <i class="bi bi-person-hearts"></i>
            </div>
            <h3>Tutores e Animais</h3>
            <p>Aceder à gestão global de tutores e seus animais</p>
        </a>

        <!-- Seção: Operações -->
        <div class="section-header">
            <h2>
                <div class="section-icon">
                    <i class="bi bi-gear"></i>
                </div>
                <span>Operações do Sistema</span>
            </h2>
        </div>

        <a href="${pageContext.request.contextPath}/GerenteServlet?action=horarios" class="menu-card operations">
            <div class="menu-card-icon">
                <i class="bi bi-calendar-week"></i>
            </div>
            <h3>Gestão de Horários</h3>
            <p>Atribuir supervisão veterinária às clínicas</p>
        </a>

        <a href="${pageContext.request.contextPath}/GerenteServlet?action=exportImport" class="menu-card operations">
            <div class="menu-card-icon">
                <i class="bi bi-arrow-down-up"></i>
            </div>
            <h3>Importar / Exportar</h3>
            <p>Gestão de dados em formato JSON de fichas clínicas</p>
        </a>

        <!-- Seção: Estatísticas -->
        <div class="section-header">
            <h2>
                <div class="section-icon">
                    <i class="bi bi-graph-up"></i>
                </div>
                <span>Estatísticas e Relatórios</span>
            </h2>
        </div>

        <a href="${pageContext.request.contextPath}/GerenteServlet?action=statsVida" class="menu-card statistics">
            <div class="menu-card-icon">
                <i class="bi bi-activity"></i>
            </div>
            <h3>Expectativa de Vida</h3>
            <p>Animais que superaram a esperança média de vida</p>
        </a>

        <a href="${pageContext.request.contextPath}/GerenteServlet?action=statsPeso" class="menu-card statistics">
            <div class="menu-card-icon">
                <i class="bi bi-speedometer2"></i>
            </div>
            <h3>Excesso de Peso</h3>
            <p>Tutores com animais acima do peso ideal</p>
        </a>

        <a href="${pageContext.request.contextPath}/GerenteServlet?action=statsCancel" class="menu-card statistics">
            <div class="menu-card-icon">
                <i class="bi bi-x-circle"></i>
            </div>
            <h3>Cancelamentos</h3>
            <p>Top tutores com cancelamentos nos últimos 3 meses</p>
        </a>

        <a href="${pageContext.request.contextPath}/GerenteServlet?action=statsSemana" class="menu-card statistics">
            <div class="menu-card-icon">
                <i class="bi bi-clipboard-data"></i>
            </div>
            <h3>Previsão Semanal</h3>
            <p>Serviços agendados para a próxima semana</p>
        </a>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>