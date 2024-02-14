function showImages(query_no)
    
    global allDisplays;
    figure;
    imshow(allDisplays{query_no});
    axis off;

end