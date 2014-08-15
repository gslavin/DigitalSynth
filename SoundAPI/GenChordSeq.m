function [ output_sig ] = GenChordSeq(seq, duration, volume, damping, wave_type)
    [seg_rows, seg_columns] = size(seq);
    % set optional args
    if ~exist('volume','var')
       volume = 0.5;
    end
    if ~exist('damping','var')
       damping = 1.7;
    end
    if ~exist('wave_type','var')
       wave_type = @DampedSin;
    end
    % expand param matrices
    duration = expandParamMatrix(duration, seg_rows, seg_columns);
    volume = expandParamMatrix(volume, seg_rows, seg_columns);
    damping = expandParamMatrix(damping, seg_rows, seg_columns);
    
    fs = 8000;
    seq_size = size(seq);
    T = duration/(seq_size(2));
    t = 0:(1/fs):T;
    output_sig = [];
    % Append sequenced chords
    for i = 1:seg_columns
        chord = seq(:,i);
        temp = zeros(1,length(t));
        % Build chords
        for j = 1:seg_rows
            freq = 2^((chord(j)-49)/12)*440;
            sig = (volume(j,i)/seg_rows)*wave_type(t, freq, damping(j,i));
            temp = AddSignals(temp, sig);
        end 
        output_sig = AppendSignals(output_sig, temp);
    end
end