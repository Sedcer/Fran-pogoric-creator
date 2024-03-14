    // Assuming randomEventChoices is an object containing arrays of random event choices
    // Modify this object and its structure according to your specific implementation
    
    // Remove "core_element" from the array of random event choices related to floating objects
    if (randomEventChoices.floating_objects && randomEventChoices.floating_objects.indexOf("core_element") !== -1) {
        randomEventChoices.floating_objects.splice(randomEventChoices.floating_objects.indexOf("core_element"), 1);
    }

    // Remove "reactor_core" from the array of random event choices related to reactor cores
    if (randomEventChoices.reactor_cores && randomEventChoices.reactor_cores.indexOf("reactor_core") !== -1) {
        randomEventChoices.reactor_cores.splice(randomEventChoices.reactor_cores.indexOf("reactor_core"), 1);
    }
});