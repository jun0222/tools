class RandomStringGenerator {
  constructor(characterSet = "alphanumeric", options = {}) {
    this.characterSet = characterSet;
    this.options = options;
  }

  generate(length) {
    const charSet = {
      numeric: "0123456789",
      alphanumeric:
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
      alphanumericSymbol:
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()",
      hiragana: this.generateHiragana(),
      katakana: this.generateKatakana(),
      customPattern: this.generateCustomPattern(),
      readablePattern: this.generateReadablePattern(),
      uuid: this.generateUUID(),
    };

    let result = "";
    const characters = charSet[this.characterSet];
    const charactersLength = characters.length;
    if (
      // 文字数指定を無視する文字種
      this.characterSet === "customPattern" ||
      this.characterSet === "readablePattern" ||
      this.characterSet === "uuid"
    ) {
      result = characters;
    } else {
      for (let i = 0; i < length; i++) {
        result += characters.charAt(
          Math.floor(Math.random() * charactersLength)
        );
      }
    }
    return result;
  }

  generateCustomPattern() {
    const words = [
      "Apple",
      "Fish",
      "Grape",
      "Kiwi",
      "Lemon",
      "Dog",
      "Cat",
      "Orange",
      "Bird",
      "Color",
      "Red",
      "Train",
      "Car",
      "Lion",
      "Tiger",
      "Family",
      "House",
      "Room",
      "Rice",
      "Road",
    ];
    const symbols = "@#$+-_&";
    const randomWord = words[Math.floor(Math.random() * words.length)];
    const randomSymbol = symbols.charAt(
      Math.floor(Math.random() * symbols.length)
    );
    const randomNumber = Math.floor(Math.random() * 900 + 100);
    return `${randomWord}${randomSymbol}${randomNumber}`;
  }

  generateHiragana() {
    // ひらがなのUnicode範囲: 3040-309F
    let hiragana = "";
    for (let i = 0x3041; i <= 0x3096; i++) {
      hiragana += String.fromCharCode(i);
    }
    return hiragana;
  }

  generateKatakana() {
    // カタカナのUnicode範囲: 30A0-30FF
    let katakana = "";
    for (let i = 0x30a1; i <= 0x30fa; i++) {
      katakana += String.fromCharCode(i);
    }
    return katakana;
  }

  generateReadablePattern() {
    const words = [
      "apple", "dog", "cat", "car", "sun", "moon", "star", "tree", "fish", "bird",
      "book", "desk", "door", "key", "pen", "cup", "bag", "hat", "box", "toy",
      "fire", "water", "wind", "rock", "sand", "gold", "blue", "red", "green", "white"
    ];
    const symbols = "_-@#";
    const numbers = "0123456789";
    
    const wordCount = this.options.wordCount || 2;
    const includeNumbers = this.options.includeNumbers !== false;
    const includeSymbols = this.options.includeSymbols !== false;
    const includeUppercase = this.options.includeUppercase !== false;
    
    let result = [];
    let selectedSymbol = null;
    
    if (includeSymbols) {
      selectedSymbol = symbols.charAt(Math.floor(Math.random() * symbols.length));
    }
    
    for (let i = 0; i < wordCount; i++) {
      let word = words[Math.floor(Math.random() * words.length)];
      
      if (includeUppercase && Math.random() > 0.5) {
        const randomIndex = Math.floor(Math.random() * word.length);
        word = word.substring(0, randomIndex) + 
               word.charAt(randomIndex).toUpperCase() + 
               word.substring(randomIndex + 1);
      }
      
      result.push(word);
      
      if (i < wordCount - 1) {
        if (includeSymbols) {
          result.push(selectedSymbol);
        } else if (includeNumbers) {
          result.push(numbers.charAt(Math.floor(Math.random() * numbers.length)));
        }
      }
    }
    
    if (includeNumbers && includeSymbols) {
      const numberLength = Math.floor(Math.random() * 3) + 1;
      let numberPart = "";
      for (let i = 0; i < numberLength; i++) {
        numberPart += numbers.charAt(Math.floor(Math.random() * numbers.length));
      }
      result.push(numberPart);
    }
    
    return result.join("");
  }

  generateUUID() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random() * 16 | 0,
          v = c == 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }
}

function generatePassword() {
  const characterSet = document.querySelector(
    'input[name="characterSet"]:checked'
  ).value;
  const length = parseInt(document.getElementById("length").value);
  
  let options = {};
  if (characterSet === "readablePattern") {
    options = {
      wordCount: parseInt(document.getElementById("wordCount").value),
      includeNumbers: document.getElementById("includeNumbers").checked,
      includeSymbols: document.getElementById("includeSymbols").checked,
      includeUppercase: document.getElementById("includeUppercase").checked
    };
  }
  
  const generator = new RandomStringGenerator(characterSet, options);
  const passwordOutput = generator.generate(length);

  document.getElementById("passwordOutput").value = passwordOutput;
}

function copyToClipboard() {
  const passwordOutput = document.getElementById("passwordOutput");
  passwordOutput.select();
  document.execCommand("copy");

  document.getElementById("copied").style.visibility = "visible";
  setTimeout(function () {
    document.getElementById("copied").style.visibility = "hidden";
  }, 2000);
}

document
  .getElementById("generateButton")
  .addEventListener("click", function () {
    generatePassword();
  });

document.getElementById("generateButton").click();

document.getElementById("copyButton").addEventListener("click", function () {
  copyToClipboard();
});

document
  .getElementById("generateButton")
  .addEventListener("mouseover", function () {
    document.getElementById("generateButton").click();
  });

document
  .getElementById("copyButton")
  .addEventListener("mouseover", function () {
    document.getElementById("copyButton").click();
  });

document.getElementById("form").addEventListener("input", function (event) {
  generatePassword();
});

document.getElementById("form").addEventListener("change", function () {
  generatePassword();
});

// 読みやすい形式が選択されたときにオプションを表示/非表示
document.querySelectorAll('input[name="characterSet"]').forEach(radio => {
  radio.addEventListener('change', function() {
    const readableOptions = document.getElementById('readableOptions');
    if (this.value === 'readablePattern') {
      readableOptions.style.display = 'block';
    } else {
      readableOptions.style.display = 'none';
    }
  });
});
