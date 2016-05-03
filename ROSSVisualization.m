clear all
close all

%declare global variables
global proposalLB
global proposalUB
global data
global noUnknowns
global priorLB
global priorUB
global expRows
global expColumns
global noExperiments

%Build elliptical target
imageColumns = 10;
imageRows = 10;
[columnsInImage rowsInImage] = meshgrid(1:imageColumns, 1:imageRows);
% % Next create the ellipse in the image.
centerRow = 5;
centerColumn = 6;
radiusRow = 3;
radiusColumn = 2;

real = [centerRow centerColumn radiusRow radiusColumn];

noUnknowns = 5;
proposalLB = [0 0 1 1 1]
proposalUB = [10 10 5 5 5]
priorLB = [0 0 1 1 1]
priorUB = [10 10 5 5 5]
ellipsePixels = (rowsInImage - centerColumn).^2 ./ radiusColumn^2 ...
    + (columnsInImage - centerRow).^2 ./ radiusRow^2 <= 1;
%determine data for Baye's experiment randomly
noExperiments = 4;
expRows = randi(10,noExperiments,1);
expColumns = randi(10,noExperiments,1);
data = zeros(noExperiments,1);
for i=1:noExperiments
    if ellipsePixels(expRows(i),expColumns(i) ==1)
        data(i) = 1;
    else
        data(i) = 0;
    end
end

% circlePixels is a 2D "logical" array.
% Now, display it.
figure; image(ellipsePixels) ;
set(gca,'YDir','normal')
newmap = ([1 1 1; 1 0 0]);
colormap([1 1 1; 1 0 0]);
title('Target', 'FontSize', 20);
imwrite(ellipsePixels,newmap,'target.jpg')

%Throw darts at evenly spaced points

%draw grid
spacing = 1; 
img = imread('target.jpg');
RGB = imread('target.jpg');
% img(spacing:spacing:end,:,:) = 0;
% img(:,spacing:spacing:end,:) = 0;
% figure; imshow(img);
% title('Target', 'FontSize', 20);
% bruteForce = zeros(imageSizeX,imageSizeY);
% for i = 1:spacing:imageSizeX
%       for j = 1:spacing:imageSizeY
%          P = impixel(RGB,i,j);
%          if (P(1) ==254)
%              bruteForce(j,i) = 1;
%          end
%       end
% end
%Brute force method
%figure;
% markerSize = 20;
%spy(bruteForce,markerSize);

%Bayesian method
%identicalColorProbability should equal 1/distance from cell
bayesUpdates = zeros(imageRows/spacing,imageColumns/spacing);
probabilityRed = ones(imageRows/spacing,imageColumns/spacing)*.4;
probabilityWhite = 1-probabilityRed;

%throw dart at random point
row1 = 0;
row2 = imageColumns;
column1 = 0;
column2 = imageRows;
row = (row2-row1).*rand(1) + row1;
column = (column2-column1).*rand(1) + column1;
% %calculate distance of all points from dart
% distanceFromDart = sqrt((i-Y)^2+(j-X)^2);
% %evaluate probabilities given dart's result
% %throw dart and most probable location and repeat
% for i = 1:imageSizeX
%       for j = 1:imageSizeY
%          distanceFromDart = sqrt((i-Y)^2+(j-X)^2);
%          probabilityRedDartGivenRed = 1/distanceFromDart;
%          probabilityRedDartGivenWhite = 1 - probabilityRedDartGivenRed;
%          probabilityWhiteDartGivenWhite = 1/distanceFromDart;
%          probabilityWhiteDartGivenRed = 1 - probabilityWhiteDartGivenWhite;
%          probabilityRedGivenRedDart = probabilityRed*probabilityRedDartGivenRed/(probabilityRed*probabilityRedDartGivenRed+probabilityWhite*probabilityRedDartGivenWhite);
%          probabilityRedGivenWhiteDart = probabilityRed*probabilityWhiteDartGivenRed/(probabilityRed*probabilityWhiteDartGivenRed+probabilityWhite*probabilityWhiteDartGivenWhite);
%          if (P(1) ==254)
%              bayesUpdates(j,i)=probabiltyRedGivenRedDart;
%          else
%              bayesUpdates(j,i)=probabilityRedGivenWhiteDart;
%          end
%       end
% end

%X = column and Y  = row
% previousThrows = 0;
%     row = centerRow; %(x2-x1).*rand(1) + x1;
%     column = centerColumn,%(y2-y1).*rand(1) + y1;
% 
% for throw=1:10
%     rowsThrown(throw) = row;
%     columnsThrown(throw) = column;
%     previousThrows = previousThrows + 1;
%     P = ellipsePixels(row,column);
%     for i = 1:imageRows
%           for j = 1:imageColumns
%              num1 = 1;
%              den1 = 1;
%              den2 = 1;
%              distanceFromDart(i,j) = sqrt((i-row)^2+(j-column)^2);
%              probabilityRedDartGivenRed = 1/(distanceFromDart(i,j)+1);
%              probabilityRedDartGivenWhite = 1 - probabilityRedDartGivenRed;
%              probabilityWhiteDartGivenWhite = 1/(distanceFromDart(i,j)+1);
%              probabilityWhiteDartGivenRed = 1 - probabilityWhiteDartGivenWhite;
%              dartFlagGivenRed(:,throw) = [probabilityRedDartGivenRed probabilityWhiteDartGivenRed];
%              dartFlagGivenWhite(:,throw) = [probabilityRedDartGivenWhite probabilityWhiteDartGivenWhite];
%              %flag dart color
%              if (P ==1)
%                  dartColor(throw,:) = [1 0];
%                  probabilityRed(row,column) = 1;
%                  probabilityWhite(row,column) = 0;
%              else
%                  dartColor(throw,:) = [0 1];
%                  probabilityWhite(row,column) = 1;
%                  probabilityRed(row,column) = 0;
%              end  
%              for ind = 1:previousThrows %check this probability calculation
%                 num1 = dartColor(ind,:)*dartFlagGivenRed(:,ind)*num1;
%                 den1 = dartColor(ind,:)*dartFlagGivenRed(:,ind)*den1;
%                 den2 = dartColor(ind,:)*dartFlagGivenWhite(:,ind)*den2;
%              end
%             probabilityRedGivenAllDarts = probabilityRed(i,j)*num1./(probabilityRed(i,j)*den1+probabilityWhite(i,j)*den2);
%             bayesUpdates(i,j)=probabilityRedGivenAllDarts;
%             for k = 1:throw
%                 %bayesUpdates(rowsThrown(k),columnsThrown(k))=dartColor(k,1);
%             end
%           end
%     end
%  
% figure; contourf(bayesUpdates)
% hold on
% row = row/spacing;
% column = column/spacing;
% scatter(column,row,'LineWidth',20) %flipping X and Y to get from rows to columns
% str = sprintf('Dart Number = %d',throw);
% title(str);
% v = reshape(bayesUpdates,1,[]);
% rowNext = row;
% columnNext = column;
% while ismember(rowNext,rowsThrown) && ismember(columnNext,columnsThrown)
%     f = randsample(length(v), 1, true, v);
%     [rowNext columnNext] = ind2sub(size(bayesUpdates), f);
% end
% row =rowNext;
% column = columnNext;
% end




%Bayesian model method

%Make initial guess for unknown parameters
current = zeros(noUnknowns,1);
%Peform MH iterations
PosteriorCurrent = Posterior(current,1);
N = 100;
theta = zeros(N*noUnknowns,noUnknowns);
acc = zeros(1,noUnknowns);
for i = 1:noUnknowns
          current = ProposalFunction(current,i);
end
% for i = 1:burnin    % First make the burn-in stage
%     for j=1:noUnknowns
%       [alpha,t, a,prob, PosteriorCatch] = MetropolisHastings(theta,current,PosteriorCurrent,j);
%     end
% end
for cycle = 1:N  % Cycle to the number of samples
    ind = 1;
     for m=1:noUnknowns % Cycle to make the thinning
            [alpha,t, a,prob, PosteriorCatch] = MetropolisHastings(theta,current,PosteriorCurrent,m);
            theta((cycle-1)*noUnknowns+m,:) = t;        % Samples accepted
            AlphaSet(cycle,m) = alpha;
            current = t;
            PosteriorCurrent = PosteriorCatch;
            acc(m) = acc(m) + a;  % Accepted ?
     end
end
 

accrate = acc/N;     % Acceptance rate,. 

%plot final predicted figure from Bayes using mean values
centerRow = mean(theta(:,1));
centerColumn = mean(theta(:,2));
radiusRow = mean(theta(:,3));
radiusColumn = mean(theta(:,4));

predictedPixels = (rowsInImage - centerColumn).^2 ./ radiusColumn^2 ...
    + (columnsInImage - centerRow).^2 ./ radiusRow^2 <= 1;
figure; image(predictedPixels) ;
set(gca,'YDir','normal')
newmap = ([1 1 1; 1 0 0]);
colormap([1 1 1; 1 0 0]);
title('Predicted Target', 'FontSize', 20);

figure;
    for i =1:noUnknowns-1
        subplot(3,3,i);
        outputTitle = sprintf('Unknown %d',i);
        paramEdges = [0:2:proposalUB(i)];
        f = histogram(theta(:,i),paramEdges);
        f.Normalization = 'probability';
        counts = f.Values;
        hold on
        line([real(i) real(i)],[0 max(counts)], 'Color', 'r')
        hold on
        xmin = min(theta(:,i));
        xmax = max(theta(:,i));
        x = xmin:1:xmax;
        hold on
        line([priorLB(i) priorLB(i)],[0 max(counts)], 'Color', 'g')
        hold on
        line([priorUB(i) priorUB(i)],[0 max(counts)], 'Color', 'g')
        title(outputTitle);
        xlabel('Value');
        ylabel('Frequency');
    end



figure; 
for k =1:noUnknowns-1
    outputTitle = sprintf('Unknown %d',k);
    subplot(3,3,k);
    plot(theta(:,k));
    hold on
    line([0 N],[real(k) real(k)], 'Color', 'r')
    hold on
    line([0 N],[proposalLB(i) proposalLB(i)], 'Color', 'g')
    line([0 N],[proposalUB(i) proposalUB(i)], 'Color', 'g')
    title(outputTitle);
    xlabel('Cycle #');
    ylabel('Value');
end

