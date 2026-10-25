function verifier(tp, partie)
fs = 8000;
t = 0:1/fs:1-1/fs;
switch partie
    case 1
        N = lire('N'); la = lire('la');
        test('N vaut 8000', isequal(N, 8000), 'N = length(t)');
        test('la est la sinusoide a 440 Hz', ~isempty(la) && numel(la)==8000 && max(abs(la - sin(2*pi*440*t))) < 1e-6, 'la = sin(2*pi*f0*t)');
    case 2
        accord = lire('accord');
        ref = (sin(2*pi*440*t) + sin(2*pi*550*t) + sin(2*pi*660*t))/3;
        test('accord = somme des 3 notes divisee par 3', ~isempty(accord) && numel(accord)==8000 && max(abs(accord - ref)) < 1e-6, 'accord = (la + dod + mi)/3');
        test('amplitude de accord inferieure a 1', ~isempty(accord) && max(abs(accord)) < 1, 'pense a diviser par 3');
    case 3
        f = lire('f'); A = lire('A');
        ok = ~isempty(A) && ~isempty(f);
        test('spectre calcule avec ts_spectre', ok, '[f, A] = ts_spectre(accord, fs)');
        if ok
            [~, i1] = min(abs(f - 440)); [~, i2] = min(abs(f - 550)); [~, i3] = min(abs(f - 660));
            test('raies de hauteur 1/3 a 440, 550 et 660 Hz', abs(A(i1)-1/3) < 0.01 && abs(A(i2)-1/3) < 0.01 && abs(A(i3)-1/3) < 0.01, 'verifie accord et fs');
        end
    case 4
        le = lire('la_extrait');
        ok = ~isempty(le) && numel(le)==8000;
        test('la_extrait existe', ok, 'la_extrait = filtfilt(b, a, accord)');
        if ok
            [f, A2] = ts_spectre(le, fs);
            [~, i440] = min(abs(f - 440)); [~, i550] = min(abs(f - 550));
            test('le la (440 Hz) est conserve', A2(i440) > 0.3, 'bande [420 460]/(fs/2)');
            test('le do# (550 Hz) est elimine', A2(i550) < 0.01, 'verifie la bande et l''ordre 4');
        end
    case 5
        dm = lire('do_maj'); sol = lire('sol');
        test('do_maj existe et amplitude < 1', ~isempty(dm) && max(abs(dm)) < 1, 'divise la somme par 3');
        if ~isempty(sol)
            [f, B] = ts_spectre(sol, fs);
            [~, ia] = min(abs(f - 392)); [~, ib] = min(abs(f - 329.63));
            test('le sol (392 Hz) est conserve', B(ia) > 0.25, 'bande autour de 392 Hz');
            test('le mi (329,63 Hz) est elimine', B(ib) < 0.05, 'bande plus etroite');
        else
            test('sol existe', false, 'sol = filtfilt(b2, a2, do_maj)');
        end
end
end

function v = lire(nom)
if evalin('base', ['exist(''' nom ''',''var'')'])
    v = evalin('base', nom);
else
    v = [];
end
end

function test(texte, cond, indice)
if cond
    fprintf('[ OK ] %s\n', texte);
else
    fprintf('[ A REVOIR ] %s -> indice : %s\n', texte, indice);
end
end