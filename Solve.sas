/*Включаем опции отладки*/
OPTIONS MPRINT MLOGIC SYMBOLGEN;

/*Создаем макрос*/
%macro count_saturday_attendance(_inDS,_dateVar,_startDate,_endDate,_studentID);
	/*Сортируем базу по дате*/
	proc sort data=&_inDS;
		by &_dateVar;
	run;
	data _null_;
		/*Отбираем только нужного студента и временной промежуток*/
		set &_inDS (where=(Student_ID=&_studentID & (&_dateVar ge "&_startDate"d) & (&_dateVar le "&_endDate"d)));
		retain i 0;
		w = weekday(&_dateVar);
		/*Считаем количество суббот, когда студент был на занятиях*/
		if attendance=1 & w=7 then do;
		i+1;
		end;
		/*В конце выводим в лог полученное число*/
		if &_dateVar="&_endDate"d then do;
		put "STUDENT >>>> " Student_ID " ATTENDANCE >>>> " i;
		end;
	run;
%mend count_saturday_attendance;

/*Вызываем макрос*/
%count_saturday_attendance(students_3qtr_2015_visits,date,07oct2015,10oct2015,120145)
%count_saturday_attendance(students_3qtr_2015_visits,date,03oct2015,12dec2015,121119)

/*Отключаем опции отладки*/
OPTIONS NOMPRINT NOMLOGIC NOSYMBOLGEN;
		