function class_label = determineLabel(filename)   
    
    if startsWith(filename, '1_')
        class_label = 'grass';
    elseif startsWith(filename, '2_')
        class_label = 'trees';
    elseif startsWith(filename, '3_')
        class_label = 'building';
    elseif startsWith(filename, '4_')
        class_label = 'aerocraft';
    elseif startsWith(filename, '5_')
        class_label = 'Cows';
    elseif startsWith(filename, '6_')
        class_label = 'Humans';
    elseif startsWith(filename, '7_')
        class_label = 'cars';
    elseif startsWith(filename, '8_')
        class_label = 'bikes';
    elseif startsWith(filename, '9_')
        class_label = 'sheep';
    elseif startsWith(filename, '10_')
        class_label = 'flowers';
    elseif startsWith(filename, '11_')
        class_label = 'signboards';
    elseif startsWith(filename, '12_')
        class_label = 'ducks';
    elseif startsWith(filename, '13_')
        class_label = 'books';
    elseif startsWith(filename, '14_')
        class_label = 'seats';
    elseif startsWith(filename, '15_')
        class_label = 'cats';
    elseif startsWith(filename, '16_')
        class_label = 'dogs';
    elseif startsWith(filename, '17_')
        class_label = 'street(s)';
    elseif startsWith(filename, '18_')
        class_label = 'boats/ships';
    elseif startsWith(filename, '19_')
        class_label = 'Full Body Human';
    elseif startsWith(filename, '20_')
        class_label = 'Water Body';
    else
        class_label = 'unknown'; 
    end
end