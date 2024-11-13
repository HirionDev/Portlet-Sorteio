<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.0/xlsx.full.min.js"></script>


<div id="sorteio">
    <div id="container-sorteio">
        <section id="resultados">
            <h1>Resultados do Sorteio</h1>
            <p id="teste"></p>
            <article id="primeiro-lugar">
                <h2>1° Lugar:</h2>
                <p id="ganhador_primeiro_luga"></p>
            </article>
            <article id="segundo-terceiro">
                <div id="segundo-lugar">
                    <h2>2° Lugar:</h2>
                    <p id="ganhador_segundo_luga"></p>
                </div>
                <div id="terceiro-lugar">
                    <h2>3° Lugar:</h2>
                    <p id="ganhador_terceiro_luga"></p>
                </div>
            </article>
            <section id="outros"></section> <!-- Para exibir outros ganhadores -->

            <div id="configuracoes">
                <section id="configuracao_numero">
                    <label for="num-premios">Número de Premiados:</label>
                    <input type="number" id="num-premios" min="3" max="10" value="3">
                </section>
                <section id="configuracao_arquivo">
                    <label for="arquivo-excel">Carregar lista de participantes:</label>
                    <input type="file" id="arquivo-excel" accept=".xls,.xlsx">
                </section>

                <button id="botao-sorteio">Realizar Sorteio</button>
            </div>
        </section>
    </div>
</div>

<script>
    let testt = "hirion"
    const test = document.querySelector("#teste")

    test.innerHTML = `${testt}`
    let participantesExcel = []; // Variável global para armazenar os participantes carregados do Excel
    let jaExecutado = false; // Controle para evitar sorteio duplicado

    // Função para iniciar o sorteio
    function startDraw(participants) {
        const numero = parseInt(document.getElementById("num-premios").value); // Obtém o número de prêmios
        let ganhador_primeiro_luga = document.querySelector(
            "#ganhador_primeiro_luga"
        );
        let ganhador_segundo_luga = document.querySelector("#ganhador_segundo_luga");
        let ganhador_terceiro_luga = document.querySelector(
            "#ganhador_terceiro_luga"
        );

        // Limpar resultados anteriores
        ganhador_primeiro_luga.innerHTML = "";
        ganhador_segundo_luga.innerHTML = "";
        ganhador_terceiro_luga.innerHTML = "";

        // Limpar outros ganhadores
        const outrosGanhadoresContainer = document.getElementById("outros");
        outrosGanhadoresContainer.innerHTML = ""; // Limpa a lista de outros ganhadores

        const ganhadores = [];
        const nomesSorteados = [];

        // Função para sortear um participante
        while (ganhadores.length < numero) {
            const index = Math.floor(Math.random() * participants.length);
            const nome = participants[index];
            if (!nomesSorteados.includes(nome)) {
                nomesSorteados.push(nome);
                ganhadores.push(nome);
            }
        }

        // Exibindo os resultados dos 3 primeiros lugares
        ganhador_primeiro_luga.innerHTML = "<strong>" + ganhadores[0] + "</strong>";
        ganhador_segundo_luga.innerHTML = "<strong>" + ganhadores[1] + "</strong>";
        ganhador_terceiro_luga.innerHTML = " <strong>" + ganhadores[2] + "</strong>";

        // Exibindo os outros ganhadores, se necessário
        if (numero > 3) {
            const listaGanhadores = document.createElement("ul"); // Criar uma lista para os ganhadores adicionais

            for (let i = 3; i < ganhadores.length; i++) {
                const item = document.createElement("li");

                // Usando o operador + para concatenar as strings
                item.innerHTML = (i + 1) + "° Lugar: <strong>" + ganhadores[i] + "</strong>";

                listaGanhadores.appendChild(item);
            }

            // Adicionar a lista de outros ganhadores ao container "outros"
            outrosGanhadoresContainer.appendChild(listaGanhadores);
        }

        jaExecutado = true; // Marca que o sorteio foi realizado
    }

    // Função para ler o arquivo Excel e extrair os participantes
    function handleFile(event) {
        const file = event.target.files[0]; // Obtém o arquivo selecionado
        if (!file) return; // Verifica se o arquivo foi selecionado

        const reader = new FileReader();
        reader.onload = function (e) {
            const data = e.target.result;

            // Usando a biblioteca xlsx para ler o conteúdo do Excel
            const workbook = XLSX.read(data, { type: "binary" });

            // Pegando o nome da primeira planilha
            const sheetName = workbook.SheetNames[0];
            const sheet = workbook.Sheets[sheetName];

            // Convertendo os dados da planilha em um formato JSON
            const json = XLSX.utils.sheet_to_json(sheet, { header: 1 });

            // Extrair apenas os nomes dos participantes (assumindo que estão na primeira coluna)
            const participants = json.map((row) => row[0]).filter((name) => name); // Remove valores vazios

            // Armazenar a lista de participantes na variável global
            participantesExcel = participants;
        };
        reader.readAsBinaryString(file);
    }

    // Adiciona o evento para ler o arquivo Excel
    document.getElementById("arquivo-excel").addEventListener("change", handleFile);

    // Adiciona um evento de clique ao botão de sorteio
    document.getElementById("botao-sorteio").addEventListener("click", function () {
        if (jaExecutado) {
            // Limpa a exibição dos outros ganhadores, caso o sorteio já tenha sido executado
            const elementos = document.querySelectorAll("#outros ul");
            elementos.forEach((el) => el.remove());
        }

        // Verifica se o arquivo Excel foi carregado
        const participantes =
            participantesExcel.length > 0
                ? participantesExcel
                : [
                    "João",
                    "Maria",
                    "Pedro",
                    "Ana",
                    "Carlos",
                    "Luana",
                    "Felipe",
                    "Roberta",
                    "Gustavo",
                    "Carla",
                ];

        startDraw(participantes); // Realiza o sorteio com a lista de participantes
    });

</script>
