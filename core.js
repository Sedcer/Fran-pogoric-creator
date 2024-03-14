window.addEventListener("load", function() {
    // Assuming randomEventChoices is an object containing arrays of random event choices
    // Modify this object and its structure according to your specific implementation
    
    // Add "reactor_core" to the array of random event choices related to Special
    if (randomEventChoices.Special && randomEventChoices.Special.indexOf("reactor_core") === -1) {
        randomEventChoices.Special.push("reactor_core");
    }
    
    // Remove "radiation" from the array of random event choices related to explosions
    if (randomEventChoices.explosion && randomEventChoices.explosion.indexOf("radiation") !== -1) {
        randomEventChoices.explosion.splice(randomEventChoices.explosion.indexOf("radiation"), 1);
    }
});
