LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

--Diana Portillo

ENTITY RelojAlarma IS
PORT(
		reloj: IN STD_LOGIC;
		apagarAlarma: IN STD_LOGIC;
		--An: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		indicadorAlarma: OUT STD_LOGIC;
		L1,L2,L3,L4: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
);
END RelojAlarma;

ARCHITECTURE PORTILLO OF RelojAlarma IS
	SIGNAL segundo: STD_LOGIC;
	SIGNAL rapido: STD_LOGIC;
	SIGNAL n,e,z,u,d,reset: STD_LOGIC;
	SIGNAL Qs: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Qum: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Qdm: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Qr: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL Quh: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Qdh: STD_LOGIC_VECTOR(3 DOWNTO 0);
	
BEGIN
		divisor: PROCESS(reloj)
			VARIABLE cuenta: STD_LOGIC_VECTOR(27 DOWNTO 0) := X"0000000";
			BEGIN
				IF RISING_EDGE(reloj) THEN
					IF cuenta = X"48009E0" THEN
						cuenta := X"0000000";
					ELSE
						cuenta := cuenta+1;
					END IF;
				END IF;
				segundo <= cuenta(22);
				rapido <= cuenta(10);
		END PROCESS;
		
		unidades: PROCESS(segundo)
			--VARIABLE cuenta: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			BEGIN
				IF RISING_EDGE(segundo) THEN
					IF Qum = "1001" THEN
						Qum <= "0000";
						n <= '1';
					ELSE
						Qum <= Qum+1;
						n <= '0';
					END IF;
				END IF;
				--Qum <= cuenta;
		END PROCESS;
			
		decenas: PROCESS(n)
			--VARIABLE cuenta: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			BEGIN
				IF RISING_EDGE(n) THEN
					IF Qdm = "0101" THEN
						Qdm <= "0000";
						e <= '1';
					ELSE
						Qdm <= Qdm+1;
						e <= '0';
					END IF;
				END IF;
				--Qdm <= cuenta;
		END PROCESS;
		
		HoraU: PROCESS(e, reset)
			--VARIABLE cuenta: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			BEGIN
				IF RISING_EDGE(e) THEN
					IF Quh = "1001" THEN
						Quh <= "0000";
						z <= '1';
					ELSE
						Quh <= Quh+1;
						z <= '0';
					END IF;
				END IF;
				IF reset = '1' THEN
					Quh <= "0000";
				END IF;
				--Quh <= cuenta;
				u <= Quh(1);
		END PROCESS;
		
		HoraD: PROCESS(z, reset)
			--VARIABLE cuenta: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
			BEGIN
				IF RISING_EDGE(z) THEN
					IF Qdh = "0010" THEN
						Qdh <= "0000";
					ELSE
						Qdh <= Qdh+1;
					END IF;
				END IF;
				IF reset = '1' THEN
					Qdh <= "0000";
				END IF;
				--Qdh <= cuenta;
				d <= Qdh(0);
		END PROCESS;
		
		inicia: PROCESS(u,d)
			BEGIN
				reset	<= (u AND d);
		END PROCESS;
		
		Contrapid: PROCESS(rapido)
			VARIABLE cuenta: STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
			BEGIN
				IF RISING_EDGE(rapido) THEN
					cuenta := cuenta+1;
				END IF;
				Qr <= cuenta;
		END PROCESS;
		
		encenderAlarma: PROCESS(Quh,apagarAlarma)
			BEGIN
				IF Quh = "0101" THEN--La alarma se enciende a las 05:00
					IF apagarAlarma = '0' THEN
						indicadorAlarma <= '1';
					ELSE
						indicadorAlarma <= '0';
					END IF;
				ELSE
					indicadorAlarma <= '0';
				END IF;
		END PROCESS;
		
		--muxy: PROCESS(Qr)
			--BEGIN
				--IF Qr = "00" THEN
					--Qs <= Qum;
				--ELSIF Qr = "01" THEN
					--Qs <= Qdm;
				--ELSIF Qr = "10" THEN
					--Qs <= Quh;
				--ELSIF Qr = "11" THEN
					--Qs <= Qdh;
				--END IF;
		--END PROCESS;
		
		--seldisplay: PROCESS(Qr)
			--BEGIN
				--CASE Qr IS
					--WHEN "00" =>
						--An <= "1110";
					--WHEN "01" =>
						--An <= "1101";
					--WHEN "10" =>
						--An <= "1011";
					--WHEN others =>
						--An <= "0111";
				--END CASE;
		--END PROCESS;
		
		WITH Qum SELECT
			L1 <= "1000000" WHEN "0000",
					"1111001" WHEN "0001",
					"0100100" WHEN "0010",
					"0110000" WHEN "0011",
					"0011001" WHEN "0100",
					"0010010" WHEN "0101",
					"0000010" WHEN "0110",
					"1111000" WHEN "0111",
					"0000000" WHEN "1000",
					"0010000" WHEN "1001",
					"0000011" WHEN others;
					
		WITH Qdm SELECT
			L2 <= "1000000" WHEN "0000",
					"1111001" WHEN "0001",
					"0100100" WHEN "0010",
					"0110000" WHEN "0011",
					"0011001" WHEN "0100",
					"0010010" WHEN "0101",
					"0000010" WHEN "0110",
					"1111000" WHEN "0111",
					"0000000" WHEN "1000",
					"0010000" WHEN "1001",
					"0000011" WHEN others;
		
		WITH Quh SELECT
			L3 <= "1000000" WHEN "0000",
					"1111001" WHEN "0001",
					"0100100" WHEN "0010",
					"0110000" WHEN "0011",
					"0011001" WHEN "0100",
					"0010010" WHEN "0101",
					"0000010" WHEN "0110",
					"1111000" WHEN "0111",
					"0000000" WHEN "1000",
					"0010000" WHEN "1001",
					"0000011" WHEN others;
					
		WITH Qdh SELECT
			L4 <= "1000000" WHEN "0000",
					"1111001" WHEN "0001",
					"0100100" WHEN "0010",
					"0110000" WHEN "0011",
					"0011001" WHEN "0100",
					"0010010" WHEN "0101",
					"0000010" WHEN "0110",
					"1111000" WHEN "0111",
					"0000000" WHEN "1000",
					"0010000" WHEN "1001",
					"0000011" WHEN others;
END PORTILLO;