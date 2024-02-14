function pr_plot(query_no)

    % Assuming you have the necessary variables
    global all_precisions_list;
    global all_recalls_list;

    prec_vals = all_precisions_list(query_no, :);
    rec_vals = all_recalls_list(query_no, :);

    figure;
    plot(rec_vals, prec_vals, '-o');
    title(['Precision-Recall Curve for Query ', num2str(query_no)]);
    xlabel('Recall');
    ylabel('Precision');
    grid on;

end
