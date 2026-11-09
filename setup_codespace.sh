#!/bin/bash
# Run inside the Codespace (World Cup Database)
cd /workspace/project
psql -U freecodecamp -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='worldcup'" | grep -q 1 || psql -U freecodecamp -d postgres -c "CREATE DATABASE worldcup"
psql -U freecodecamp -d worldcup <<'SQL'
CREATE TABLE IF NOT EXISTS teams(team_id SERIAL PRIMARY KEY, name VARCHAR(50) UNIQUE NOT NULL);
CREATE TABLE IF NOT EXISTS games(game_id SERIAL PRIMARY KEY, year INT NOT NULL, round VARCHAR(50) NOT NULL, winner_id INT NOT NULL REFERENCES teams(team_id), opponent_id INT NOT NULL REFERENCES teams(team_id), winner_goals INT NOT NULL, opponent_goals INT NOT NULL);
SQL
for f in insert_data.sh queries.sh; do curl -sLo $f https://raw.githubusercontent.com/skypro1111/worldcup-database/main/$f; done
chmod +x insert_data.sh queries.sh
./insert_data.sh > /dev/null
psql -U freecodecamp -d worldcup -tAc "SELECT (SELECT COUNT(*) FROM teams) || ' teams, ' || (SELECT COUNT(*) FROM games) || ' games'"
echo "World Cup ready. Now click Run in CodeRoad."
