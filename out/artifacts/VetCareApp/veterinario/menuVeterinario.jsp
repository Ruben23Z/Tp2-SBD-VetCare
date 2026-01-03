<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <title>Painel Veterinário</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f4f9;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }

        .btn-agenda {
            display: block;
            width: 100%;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-align: center;
            text-decoration: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 30px;
            transition: transform 0.2s;
        }

        .btn-agenda:hover {
            transform: scale(1.02);
        }

        .search-box {
            position: relative;
        }

        input[type="text"] {
            width: 100%;
            padding: 15px;
            font-size: 16px;
            border: 2px solid #ddd;
            border-radius: 30px;
            outline: none;
            box-sizing: border-box;
        }

        input[type="text"]:focus {
            border-color: #667eea;
        }

        .results {
            position: absolute;
            width: 100%;
            background: white;
            border: 1px solid #ddd;
            max-height: 250px;
            overflow-y: auto;
            z-index: 1000;
            display: none;
            border-radius: 0 0 15px 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-top: 5px;
        }

        .result-item {
            padding: 12px 20px;
            cursor: pointer;
            border-bottom: 1px solid #eee;
            transition: background 0.2s;
        }

        .result-item:hover {
            background-color: #f0f8ff;
            color: #667eea;
        }

        .result-item strong {
            font-size: 1.1em;
        }

        .result-item span {
            color: #777;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>👨‍⚕️ Área do Veterinário</h1>

    <a href="${pageContext.request.contextPath}/VeterinarioServlet?action=listaChamada" class="btn-agenda">
        📋 Minha Lista de Chamada (Hoje)
    </a>

    <hr style="border: 0; border-top: 1px solid #eee; margin: 30px 0;">

    <h3 style="text-align: center; color: #555;">🔍 Pesquisar Paciente por Tutor</h3>
    <div class="search-box">
        <input type="text" id="searchTutor" placeholder="Digite o nome do tutor..." autocomplete="off"
               onkeyup="buscarAnimais()">
        <div id="searchResults" class="results"></div>
    </div>

    <div style="text-align: center; margin-top: 20px;">
        <a href="${pageContext.request.contextPath}/logout.jsp" style="color: #f44336; text-decoration: none;">Sair</a>
    </div>
</div>

<script>
    function buscarAnimais() {
        let termo = document.getElementById("searchTutor").value;
        let resultsDiv = document.getElementById("searchResults");

        if (termo.length < 2) {
            resultsDiv.style.display = "none";
            return;
        }

        fetch('${pageContext.request.contextPath}/VeterinarioServlet?action=buscarAnimaisAJAX&termo=' + termo)
            .then(response => response.json())
            .then(data => {
                resultsDiv.innerHTML = "";
                if (data.length > 0) {
                    resultsDiv.style.display = "block";
                    data.forEach(animal => {
                        let div = document.createElement("div");
                        div.className = "result-item";
                        div.innerHTML = "<strong>" + animal.nome + "</strong> <br> <span>Tutor NIF: " + animal.dono + "</span>";
                        div.onclick = function () {
                            window.location.href = "${pageContext.request.contextPath}/VeterinarioServlet?action=consultarFicha&idPaciente=" + animal.id;
                        };
                        resultsDiv.appendChild(div);
                    });
                } else {
                    resultsDiv.style.display = "none";
                }
            })
            .catch(err => console.error(err));
    }
</script>
</body>
</html>