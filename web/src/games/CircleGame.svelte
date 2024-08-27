<script lang="ts">
    import { onMount } from "svelte";
    let canvas;
    let ctx;
    let W, H, degrees = 0, new_degrees = 0, color = "#38D5AF";
    let txtcolor = "#ffffff", bgcolor = "#2B312B", bgcolor2 = "#068f6d", bgcolor3 = "#00ff00";
    let key_to_press, g_start, g_end, animation_loop;
    let needed = 4, streak = 0, circle_started = false, time = 2;

    function getRandomInt(min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min + 1) + min);
    }

    function StartCircle() {
        ctx.clearRect(0, 0, W, H);
        ctx.beginPath();
        ctx.strokeStyle = bgcolor;
        ctx.lineWidth = 20;
        ctx.arc(W / 2, H / 2, Math.min(W, H) / 2 - 10, 0, Math.PI * 2, false);
        ctx.stroke();
        ctx.beginPath();
        ctx.strokeStyle = correct === true ? bgcolor3 : bgcolor2;
        ctx.lineWidth = 20;
        ctx.arc(W / 2, H / 2, Math.min(W, H) / 2 - 10, g_start - 90 * Math.PI / 180, g_end - 90 * Math.PI / 180, false);
        ctx.stroke();
        let radians = degrees * Math.PI / 180;
        ctx.beginPath();
        ctx.strokeStyle = color;
        ctx.lineWidth = 40;
        ctx.arc(W / 2, H / 2, Math.min(W, H) / 2 - 20, radians - 0.1 - 90 * Math.PI / 180, radians - 90 * Math.PI / 180, false);
        ctx.stroke();
        ctx.fillStyle = txtcolor;
        ctx.font = "100px sans-serif";
        let text_width = ctx.measureText(key_to_press).width;
        ctx.fillText(key_to_press, W / 2 - text_width / 2, H / 2 + 35);
    }

    function draw() {
        if (typeof animation_loop !== undefined) clearInterval(animation_loop);
        g_start = getRandomInt(20, 40) / 10;
        g_end = getRandomInt(5, 10) / 10;
        g_end = g_start + g_end;
        degrees = 0;
        new_degrees = 360;
        key_to_press = '' + getRandomInt(1, 4);
        animation_loop = setInterval(animate_to, time);
    }

    function animate_to() {
        if (degrees >= new_degrees) {
            CircleFail();
            return;
        }
        degrees += 2;
        StartCircle();
    }

    function correct() {
        streak += 1;
        if (streak == needed) {
            clearInterval(animation_loop);
            endGame(true);
        } else {
            draw();
        }
    }

    function CircleFail() {
        clearInterval(animation_loop);
        endGame(false);
    }

    function startGame() {
        document.getElementById('circle').style.display = 'block';
        document.getElementById('circle').style.pointerEvents = 'auto';
        circle_started = true;
        draw();
    }

    function endGame(status) {
        document.getElementById('circle').style.display = 'none';
        circle_started = false;
        let endResult = status ? true : false;
        fetch(`https://ps-ui/circle-result`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({endResult})
        });
        streak = 0;
        needed = 4;
    }

    export function setupCircleGame(data: { circles?: number; time?: number }) {
        needed = data.circles ?? 4;
        time = data.time ?? 2;
        startGame();
    }

    onMount(() => {
        canvas = document.getElementById("circle");
        ctx = canvas.getContext("2d");
        W = window.innerWidth * 0.2;
        H = window.innerHeight * 0.2;
        canvas.width = W;
        canvas.height = H;

        window.addEventListener("message", (event) => {
            if (event.data.action == "circle-start") {
                needed = event.data.circles ?? 4;
                time = event.data.time ?? 2;
                startGame();
            }
        });

        document.addEventListener("keydown", function (ev) {
            let key_pressed = ev.key;
            let valid_keys = ['1', '2', '3', '4'];
            if (valid_keys.includes(key_pressed) && circle_started) {
                if (key_pressed === key_to_press) {
                    let d_start = (180 / Math.PI) * g_start;
                    let d_end = (180 / Math.PI) * g_end;
                    if (degrees < d_start || degrees > d_end) {
                        CircleFail();
                    } else {
                        correct();
                    }
                } else {
                    CircleFail();
                }
            }
        });
    });
</script>

<div class="absolute inset-0 flex items-center justify-center" style="pointer-events: none; z-index: 100;">
    <canvas id="circle" class="w-auto h-auto" style="display: none;"></canvas>
</div>