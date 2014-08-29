% Defines a more limited envelope based on attack, decay, and sustain
function [output_sig] = ADSEnvelope(sig, attack, decay, sustain)
    levels = [0 attack(1) decay(1) sustain(1)];
    pivots = [0 attack(2) decay(2) sustain(2)];
    output_sig = Envelope(sig, levels, pivots);

end

