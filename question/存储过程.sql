-- 以下是一个示例 SQL 存储过程，用于从数据字典表中获取指定字典的所有值，并将它们插入到另一个表中的相应字段中：

DELIMITER //
CREATE PROCEDURE insert_values_from_dict(IN dict_name VARCHAR(50))
BEGIN
    DECLARE value VARCHAR(50);
    DECLARE done INT DEFAULT FALSE;
    DECLARE cursor_dict CURSOR FOR
        SELECT `value` FROM dictionary_table WHERE `name` = dict_name;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cursor_dict;

    read_loop: LOOP
        FETCH cursor_dict INTO value;
        IF done THEN
            LEAVE read_loop;
        END IF;

        INSERT INTO other_table (column_name) VALUES (value);
    END LOOP;

    CLOSE cursor_dict;
END//
DELIMITER ;

-- 调用存储过程
CALL insert_values_from_dict('dict');
