function [res, sse, ssr, fval, pval, coeff, dof, ts_length] = fitme(var, ts)
    % var(:,:,:,1) = yvariable; var(:,:,:,2:end) = xvariable
    ix = length(var(:, 1, 1, 1));
    iy = length(var(1, :, 1, 1));
    res(1:ix, 1:iy, 1:ts) = nan;  % Use ts instead of 252
    sse(1:ix, 1:iy) = nan;
    ssr(1:ix, 1:iy) = nan;
    dof(1:ix, 1:iy) = nan;
    fval(1:ix, 1:iy) = nan;
    pval(1:ix, 1:iy) = nan;
    len = length(var(1, 1, 1, :));
    coeff(1:ix, 1:iy, 1:len) = nan;
    ts_length(1:ix, 1:iy) = nan;

    for i = 1:ix
        for j = 1:iy
            z = squeeze(var(i, j, :, :));
            nanval = any(isnan(z), 2);  % Find rows with NaN
            tt = 1:ts;  % Use ts instead of 252
            tt(nanval) = [];
            z(nanval, :) = [];
            nn = sum(nanval);  % Count of rows with NaN
            ts_length(i,j)=length(tt);
            if nn < 720
                p = trainRegressionModel(z);
                x = p.LinearModel.Residuals(:, 1);
                res(i, j, 1:ts) = nan;  % Use ts instead of 252
                res(i, j, tt) = table2array(x);
                sse(i, j) = p.LinearModel.SSE;
                ssr(i, j) = p.LinearModel.SSR;
                dof(i, j) = p.LinearModel.DFE;
                coeff(i, j, :) = p.LinearModel.Coefficients.Estimate(:, 1);
            else
                res(i, j, :) = nan;
                sse(i, j) = 0;
                ssr(i, j) = 0;
                dof(i, j) = 0;
                coeff(i, j, :) = 0;
            end

            if sse(i, j) ~= 0
                [pv, ff] = coefTest(p.LinearModel);
                pval(i, j) = pv;
                fval(i, j) = ff;
            else
                pval(i, j) = NaN;
                fval(i, j) = NaN;
            end
        end
    end
end
 