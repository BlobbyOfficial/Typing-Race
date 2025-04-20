// script.js
let promptText = document.getElementById('prompt-text');
let userInput = document.getElementById('user-input');
let timerElement = document.getElementById('timer');
let statusElement = document.getElementById('status');
let accuracyElement = document.getElementById('accuracy');
let wpmElement = document.getElementById('wpm');
let restartButton = document.getElementById('restart-btn');

let startTime, interval;
let isTyping = false;
let time = 0;
let typedText = '';
let correctText = '';
let totalChars = 0;
let correctChars = 0;

// Function to start the typing race
function startRace() {
    startTime = Date.now();
    interval = setInterval(updateTime, 1000);
    isTyping = true;
    statusElement.textContent = 'Go! Start typing!';
    correctText = promptText.textContent;
    totalChars = correctText.length;
}

// Function to stop the race when the user finishes typing correctly
function stopRace() {
    clearInterval(interval);
    statusElement.textContent = 'You did it! Time: ' + time + ' seconds!';
}

// Update the timer
function updateTime() {
    time = Math.floor((Date.now() - startTime) / 1000);
    timerElement.textContent = 'Time: ' + time + 's';
}

// Function to calculate accuracy and WPM
function calculateStats() {
    // Calculate correct characters typed
    correctChars = 0;
    for (let i = 0; i < typedText.length; i++) {
        if (typedText[i] === correctText[i]) {
            correctChars++;
        }
    }

    // Calculate accuracy percentage
    let accuracy = (correctChars / typedText.length) * 100;
    accuracy = Math.round(accuracy);
    accuracyElement.textContent = 'Accuracy: ' + accuracy + '%';

    // Calculate words per minute (WPM)
    let wordsTyped = typedText.split(' ').length;
    let minutes = time / 60;
    let wpm = Math.round(wordsTyped / minutes);
    wpmElement.textContent = 'WPM: ' + wpm;
}

// Check the user's input as they type
userInput.addEventListener('input', function () {
    if (!isTyping) {
        startRace();
    }

    typedText = userInput.value;

    // Calculate accuracy and WPM live
    calculateStats();

    if (typedText === correctText) {
        stopRace();
    }
});

// Restart the game
restartButton.addEventListener('click', function () {
    userInput.value = '';
    statusElement.textContent = 'Start typing!';
    timerElement.textContent = 'Time: 0s';
    accuracyElement.textContent = 'Accuracy: 0%';
    wpmElement.textContent = 'WPM: 0';
    promptText.textContent = 'The quick brown fox jumps over the lazy dog.';
    time = 0;
    typedText = '';
    isTyping = false;
});
