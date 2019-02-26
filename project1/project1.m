%load file
finger_genuine = load('finger_genuine.score');
finger_impostor = load('finger_impostor.score');
hand_genuine = load('hand_genuine.score');
hand_impostor =load('hand_impostor.score');

%get the size of the file
finger1=length(finger_genuine);
finger2=length(finger_impostor);
hand1=length(hand_genuine);
hand2=length(hand_impostor);
disp('count finger genuine');
disp(finger1);
disp('count finger impostor');
disp(finger2);
disp('count hand genuine');
disp(hand1);
disp('count hand impostor');
disp(hand2);

finger1_max = max(finger_genuine);
finger2_max = max(finger_impostor);
hand1_max = max(hand_genuine);
hand2_max = max(hand_impostor);

finger1_min = min(finger_genuine);
finger2_min = min(finger_impostor);
hand1_min = min(hand_genuine);
hand2_min = min(hand_impostor);

finger1_mean = mean(finger_genuine);
finger2_mean = mean(finger_impostor);
hand1_mean = mean(hand_genuine);
hand2_mean = mean(hand_impostor);

finger1_variance = var(finger_genuine);
finger2_variance = var(finger_impostor);
hand1_variance = var(hand_genuine);
hand2_variance = var(hand_impostor);

disp('max finger genuine');
disp(finger1_max);
disp('max finger impostor');
disp(finger2_max);
disp('max hand genuine');
disp(hand1_max);
disp('max hand impostor');
disp(hand2_max);

disp('min finger genuine');
disp(finger1_min);
disp('min finger impostor');
disp(finger2_min);
disp('min hand genuine');
disp(hand1_min);
disp('min hand impostor');
disp(hand2_min);

disp('mean finger genuine');
disp(finger1_mean);
disp('mean finger impostor');
disp(finger2_mean);
disp('mean hand genuine');
disp(hand1_mean);
disp('mean hand impostor');
disp(hand2_mean);

disp('variance finger genuine');
disp(finger1_variance);
disp('variance finger impostor');
disp(finger2_variance);
disp('variance hand genuine');
disp(hand1_variance);
disp('variance hand impostor');
disp(hand2_variance);


finger_dprime = abs((finger1_mean-finger2_mean))/sqrt((finger1_variance+finger2_variance)/2);
hand_dprime = abs((hand1_mean-hand2_mean))/sqrt((hand1_variance+hand2_variance)/2);

disp('dprime finger');
disp(finger_dprime);
disp('dprime hand');
disp(hand_dprime);

figure;
histogram(finger_genuine,'orientation','vertical');
hold on
histogram(finger_impostor,'orientation','vertical');
legend('Genuine', 'Imposter')
title('Histogram of Fingers')
xlabel('Number of scores')
ylabel('Scores Distribution')
hold off
figure;
histogram(hand_genuine,'orientation','vertical');
hold on;
histogram(hand_impostor,'orientation','vertical');
legend('Genuine', 'Imposter')
title('Histogram of Hand')
xlabel('Number of scores')
ylabel('Scores Distribution')
hold off;

Fingerprint_matcher = 32;
Hand_matcher = 45;
finger_fmr = size(find(finger_impostor>=Fingerprint_matcher),1)/finger1;
disp('FMR finger');
disp(finger_fmr);
finger_fnmr = size(find(finger_genuine<Fingerprint_matcher),1)/finger2;
disp('FNMR finger');
disp(finger_fnmr);
hand_fmr = size(find(hand_impostor<Hand_matcher),1)/hand1;
disp('FMR hand');
disp(hand_fmr);
hand_fnmr = size(find(hand_genuine>=Hand_matcher),1)/hand2;
disp('FNMR hand genuine');
disp(hand_fnmr);


%ROC Curves

% Opening and reading file
Finger_Gen = fopen('finger_genuine.score','r');
Finger_Imp = fopen('finger_impostor.score','r');
Hand_Gen = fopen('hand_genuine.score','r');
Hand_Imp = fopen('hand_impostor.score','r');

% extracting files
Gen_Finger_Array = fscanf(Finger_Gen,'%f');
Imp_Finger_Array = fscanf(Finger_Imp,'%f');
Gen_Hand_Array = fscanf(Hand_Gen,'%f');
Imp_Hand_Array = fscanf(Hand_Imp,'%f');

fprintf('\nDraw the ROC curve by the given genuine and impostor scores: \n')
c = input('Would you like to provide Genuine and Imposter scores [Y/N]: ','s');
if(c == 'Y')
    gen = input('Genuine Scores:', 's');
    imp = input('Imposter Scores:', 's');
    d = input('Type of the score: \n1)Distance             2)Similarity\n Type 1 or 2: ','s');
    load_gen = load(gen);
    load_imp = load(imp);
   
    Start_Array = min([load_gen;load_imp]);
    End_Array = max([load_gen;load_imp]);
    
    if(Start_Array == 0)
        Start_Array = 1;
    end
    
    if(End_Array == 0)
        End_Arrya = 1;
    end
    if(d=='1')
        [Imp_ROC, Gen_ROC] = ROCDIS(load_gen,load_imp,Start_Array,End_Array);
    elseif(d=='2')
        [Imp_ROC, Gen_ROC] = ROC(load_gen,load_imp,Start_Array,End_Array);
    end
    
     for i = 1:length(Imp_ROC)
        if(Imp_ROC(i)==Gen_ROC(i))
            disp('EER');
            disp(Imp_ROC(i));
        end
    end 
    
    figure;
    plot(Imp_ROC,Gen_ROC)

    title('ROC Curve')
    xlabel('FMR')
    ylabel('FNRM')
    
    AUC=abs(trapz(Imp_ROC,Gen_ROC));
    disp('AUC');
    disp(AUC);
end

if(c == 'N')
    Start_Array = min([Gen_Hand_Array;Imp_Hand_Array]);
    End_Array = max([Gen_Hand_Array;Imp_Hand_Array]);

    if(Start_Array == 0)
        Start_Array = 1;
    end
    if(End_Array == 0)
        End_Arrya = 1;
    end

    [Hand_Imp_ROC, Hand_Gen_ROC] = ROCDIS(Gen_Hand_Array,Imp_Hand_Array,Start_Array,End_Array);

     for A = 1:length(Hand_Imp_ROC)
        if(Hand_Imp_ROC(A)==Hand_Gen_ROC(A))
            disp('hand');
            disp(Hand_Imp_ROC(A));
        end
     end
    
    figure;
    plot(Hand_Imp_ROC,Hand_Gen_ROC)
    title('Hand ROC Curve')
    xlabel('FMR')
    ylabel('FNRM')
    
    Start_Array = min([Gen_Finger_Array;Imp_Finger_Array]);
    End_Array = max([Gen_Finger_Array;Imp_Finger_Array]);

    if(Start_Array == 0)
        Start_Array = 1;
    end
    if(End_Array == 0)
        End_Arrya = 1;
    end
    
    
    [Finger_Imp_ROC, Finger_Gen_ROC] = ROC(Gen_Finger_Array,Imp_Finger_Array,Start_Array,End_Array);
    
    for i = 1:length(Finger_Imp_ROC)
        if(Finger_Imp_ROC(i)==Finger_Gen_ROC(i))
            disp('finger EER');
            disp(Finger_Imp_ROC(i));
        end
    end
    
    figure;
    plot(Finger_Imp_ROC,Finger_Gen_ROC)
    title('Finger ROC Curve')
    xlabel('FMR')
    ylabel('FNRM')
    
    AUC=trapz(Hand_Imp_ROC,Hand_Gen_ROC);
    disp('hand AUC');
    disp(AUC);
    
    AUC1=abs(trapz(Finger_Imp_ROC,Finger_Gen_ROC));
    disp('finger AUC');
    disp(AUC1);
    
    figure;
    x = 0:1;
    y = x;
    plot(Finger_Imp_ROC,Finger_Gen_ROC)
    hold on 
    plot(Hand_Imp_ROC,Hand_Gen_ROC)
    hold on 
    plot(x,y)
    title('Both ROC Curve')
    legend('Finger', 'Hand')
    xlabel('FMR')
    ylabel('FNRM')
    
   
end

