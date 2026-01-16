class RandomStringGenerator {
  constructor(type = "uuid") {
    this.type = type;
  }

  generate(length) {
    const charSets = {
      numeric: "0123456789",
      alphanumeric: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
      alphanumericSymbol: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()",
      hiragana: this.generateHiraganaSet(),
      katakana: this.generateKatakanaSet(),
    };

    switch (this.type) {
      case "uuid":
        return this.generateUUID();
      case "customPattern":
        return this.generateCustomPattern();
      case "numeric":
      case "alphanumeric":
      case "alphanumericSymbol":
      case "hiragana":
      case "katakana":
        return this.generateFromCharset(charSets[this.type], length);
      default:
        return this.generateUUID();
    }
  }

  generateFromCharset(charset, length) {
    let result = "";
    for (let i = 0; i < length; i++) {
      result += charset.charAt(Math.floor(Math.random() * charset.length));
    }
    return result;
  }

  generateUUID() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random() * 16 | 0,
          v = c == 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }

  generateCustomPattern() {
    const words = [
      "Apple", "Fish", "Grape", "Kiwi", "Lemon", "Dog", "Cat", "Orange",
      "Bird", "Color", "Red", "Train", "Car", "Lion", "Tiger", "Family",
      "House", "Room", "Rice", "Road"
    ];
    const symbols = "@#$+-_&";
    const randomWord = words[Math.floor(Math.random() * words.length)];
    const randomSymbol = symbols.charAt(Math.floor(Math.random() * symbols.length));
    const randomNumber = Math.floor(Math.random() * 900 + 100);
    return `${randomWord}${randomSymbol}${randomNumber}`;
  }

  generateHiraganaSet() {
    let hiragana = "";
    for (let i = 0x3041; i <= 0x3096; i++) {
      hiragana += String.fromCharCode(i);
    }
    return hiragana;
  }

  generateKatakanaSet() {
    let katakana = "";
    for (let i = 0x30a1; i <= 0x30fa; i++) {
      katakana += String.fromCharCode(i);
    }
    return katakana;
  }
}

// Types that don't use length parameter
const fixedLengthTypes = ["uuid", "customPattern"];

function getSelectedType() {
  return document.querySelector('input[name="type"]:checked').value;
}

function updateUI() {
  const type = getSelectedType();
  const lengthRow = document.getElementById("lengthRow");
  const commandText = document.getElementById("commandText");

  if (fixedLengthTypes.includes(type)) {
    lengthRow.classList.remove("visible");
    commandText.textContent = `generate --type ${type}`;
  } else {
    lengthRow.classList.add("visible");
    const length = document.getElementById("length").value;
    commandText.textContent = `generate --type ${type} --len ${length}`;
  }

  // Update active state
  document.querySelectorAll(".type-option").forEach(opt => {
    const input = opt.querySelector("input");
    if (input.checked) {
      opt.classList.add("active");
    } else {
      opt.classList.remove("active");
    }
  });
}

function generateOutput() {
  const type = getSelectedType();
  const length = parseInt(document.getElementById("length").value);

  const generator = new RandomStringGenerator(type);
  const output = generator.generate(length);

  document.getElementById("output").textContent = output;
  updateUI();
}

function copyToClipboard() {
  const output = document.getElementById("output").textContent;
  navigator.clipboard.writeText(output).then(() => {
    const copyBtn = document.getElementById("copyButton");
    copyBtn.classList.add("copied");
    copyBtn.innerHTML = `
      <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
        <path d="M13.854 3.646a.5.5 0 0 1 0 .708l-7 7a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L6.5 10.293l6.646-6.647a.5.5 0 0 1 .708 0z"/>
      </svg>
      Copied!
    `;

    setTimeout(() => {
      copyBtn.classList.remove("copied");
      copyBtn.innerHTML = `
        <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
          <path d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1v-1z"/>
          <path d="M9.5 1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5h3zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3z"/>
        </svg>
        Copy
      `;
    }, 2000);
  });
}

// Event listeners
document.getElementById("generateButton").addEventListener("click", generateOutput);
document.getElementById("copyButton").addEventListener("click", copyToClipboard);

// Generate on hover
document.getElementById("generateButton").addEventListener("mouseover", generateOutput);

// Type selection change
document.querySelectorAll('input[name="type"]').forEach(radio => {
  radio.addEventListener("change", () => {
    updateUI();
    generateOutput();
  });
});

// Length change
document.getElementById("length").addEventListener("input", generateOutput);
document.getElementById("length").addEventListener("change", generateOutput);

// Initial generation
updateUI();
generateOutput();
