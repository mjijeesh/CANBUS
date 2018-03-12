--------------------------------------------------------------------------------
-- 
-- CAN with Flexible Data-Rate IP Core 
-- 
-- Copyright (C) 2017 Ondrej Ille <ondrej.ille@gmail.com>
-- 
-- Project advisor: Jiri Novak <jnovak@fel.cvut.cz>
-- Department of Measurement         (http://meas.fel.cvut.cz/)
-- Faculty of Electrical Engineering (http://www.fel.cvut.cz)
-- Czech Technical University        (http://www.cvut.cz/)
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy 
-- of this VHDL component and associated documentation files (the "Component"), 
-- to deal in the Component without restriction, including without limitation 
-- the rights to use, copy, modify, merge, publish, distribute, sublicense, 
-- and/or sell copies of the Component, and to permit persons to whom the 
-- Component is furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in 
-- all copies or substantial portions of the Component.
-- 
-- THE COMPONENT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
-- AUTHORS OR COPYRIGHTHOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE COMPONENT OR THE USE OR OTHER DEALINGS 
-- IN THE COMPONENT.
-- 
-- The CAN protocol is developed by Robert Bosch GmbH and protected by patents. 
-- Anybody who wants to implement this IP core on silicon has to obtain a CAN 
-- protocol license from Bosch.
-- 
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Purpose:
--  Combinational decoder for TXT buffer priority. Considers priority, bufffer
--  validity. Generic amount of buffers is available (up to 8). Decoder consists
--  of 3 levels of comparators (4+2+1). If two frames have the same priority,
--  a frame with lower index is selected.
--                                                                                                                                                   
--------------------------------------------------------------------------------
-- Revision History:
--    12.02 2018   Created file
--------------------------------------------------------------------------------

Library ieee;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;
use work.CANconstants.all;
use work.ID_transfer.all;

entity priorityDecoder is
  generic(
    buf_count :  natural range 1 to 8
  );
  port( 
    
    -- No clock, nor reset, decoder is combinational only!
    
    -------------------------
    -- Buffer information
    -------------------------
    signal prio       : in  txtb_priorities_type;
    signal prio_valid : in  std_logic_vector(buf_count - 1 downto 0);
    
    -----------------------
    -- Output interface
    -----------------------
    
    -- Whether selected buffer is valid 
    -- (at least one of the buffers must be non-empty and allowed)
    signal output_valid   : out  boolean;
    
    -- Index of highest priority buffer which is non-empty and allowed
    -- for transmission
    signal output_index      : out  natural range 0 to buf_count - 1
      
  );
end entity;

architecture rtl of priorityDecoder is
    
  
  -- Level 0 aliases for input signals to provide variable signal width
  type level0_priority_type  is array (7 downto 0) of
          std_logic_vector(2 downto 0);
  signal l0_prio        : level0_priority_type;
  signal l0_valid       : std_logic_vector(7 downto 0);
  
  
  -- Level 1 priorities and valid indicators
  type level1_priority_type  is array (3 downto 0) of
          std_logic_vector(2 downto 0);
  type level1_comp_valid_type is array (3 downto 0) of
          std_logic_vector(1 downto 0);
  signal l1_prio        : level1_priority_type;
  signal l1_valid       : std_logic_vector(3 downto 0);
  signal l1_winner      : std_logic_vector(3 downto 0);
  
  -- Level 2 priorities and valid indicators
  type level2_priority_type  is array (1 downto 0) of
          std_logic_vector(2 downto 0);
  type level2_comp_valid_type is array (3 downto 0) of
          std_logic_vector(1 downto 0);
  signal l2_prio        : level1_priority_type;
  signal l2_valid       : std_logic_vector(1 downto 0);
  signal l2_winner      : std_logic_vector(3 downto 0);
  
  -- Level 3, we dont need the priorities, we only need the
  -- outcome which of them is bigger (since there is no next stage)
  signal l3_valid       : std_logic;
  signal l3_winner      : std_logic;
  
  constant LOWER_TREE   : std_logic := '0';
  constant UPPER_TREE   : std_logic := '1';  

begin
  
  -------------------------
  -- Level 0 - aliases
  -------------------------
  l0_gen: for i in 0 to buf_count - 1 generate
    
    -- Since we cover "00" as inactive value, instead of
    -- active values "01", "10" or "11", rather make sure
    -- that input values are properly defined
    l0_val_proc:process(prio_valid)
    begin
      if (prio_valid(i) /= '0' and prio_valid(i) /= '1') then
        report "Input values not exactly defined" severity error;
      end if;
    end process;
  
    l0_prio(i)  <= prio(i);
    l0_valid(i) <= prio_valid(i);
    
  end generate;
  
  
  fill_zeroes_gen:if (buf_count < 8) generate
    l0_prio(7 downto buf_count)  <= (OTHERS => (OTHERS => '0'));
    l0_valid(7 downto buf_count) <= (OTHERS => '0');
  end generate;
    
    
  -------------------------
  -- Level 1 comparators
  -------------------------
  l1_prio_dec_proc:process(l0_valid, l0_prio)
  variable tmp : level1_comp_valid_type := (OTHERS => (OTHERS => '0'));
  begin
    for i in 0 to 3 loop
      tmp(i) := l0_valid(2 * i + 1 downto 2 * i);
      case tmp(i) is
      when "01" =>
            l1_prio(i)      <= l0_prio(2 * i);
            l1_valid(i)     <= '1'; 
            l1_winner(i)    <= LOWER_TREE;
  
      when "10" =>
            l1_prio(i)      <= l0_prio(2 * i + 1);
            l1_valid(i)     <= '1'; 
            l1_winner(i)    <= UPPER_TREE;
  
      when "11" => 
            if (unsigned(l0_prio(2 * i)) > unsigned(l0_prio(2 * i + 1))) then
              l1_prio(i)    <= l0_prio(2 * i);
              l1_winner(i)  <= LOWER_TREE;
            else
              l1_prio(i)    <= l0_prio(2 * i + 1);
              l1_winner(i)  <= UPPER_TREE;
            end if;
            l1_valid(i)     <= '1';  
  
      when "00" =>
            l1_valid(i)     <= '0';
            l1_prio(i)      <= l0_prio(2 * i + 1);
            l1_winner(i)    <= UPPER_TREE;
  
      when others => 
            l1_valid(i)     <= '0';
            l1_prio(i)      <= l0_prio(2 * i + 1);
            l1_winner(i)    <= UPPER_TREE;
  
      end case;
    end loop;
  end process; 


  -------------------------
  -- Level 2 comparators
  -------------------------
  l2_prio_dec_proc:process(l1_valid, l1_prio)
  variable tmp : level2_comp_valid_type := (OTHERS => (OTHERS => '0'));
  begin
    for i in 0 to 1 loop
      tmp(i) := l0_valid(2 * i + 1 downto 2 * i);
    
      case tmp(i) is
      when "01" => 
            l2_prio(i)      <= l1_prio(2 * i);
            l2_valid(i)     <= '1'; 
            l2_winner(i)    <= LOWER_TREE;
            
      when "10" => 
            l2_prio(i)      <= l1_prio(2 * i + 1);
            l2_valid(i)     <= '1'; 
            l2_winner(i)    <= UPPER_TREE;
            
      when "11" => 
            if (unsigned(l1_prio(2 * i)) > unsigned(l1_prio(2 * i + 1))) then
              l2_prio(i)    <= l1_prio(2 * i);
              l2_winner(i)  <= LOWER_TREE;
            else
              l2_prio(i)    <= l1_prio(2 * i + 1);
              l2_winner(i)  <= UPPER_TREE;
            end if;
            l2_valid(i)     <= '1';  
             
      when "00" =>
            l2_valid(i)     <= '0';
            l2_prio(i)      <= l1_prio(2 * i + 1);
            l2_winner(i)    <= UPPER_TREE;
            
      when others => 
            l2_valid(i)     <= '0';
            l2_prio(i)      <= l1_prio(2 * i + 1);
            l2_winner(i)    <= UPPER_TREE;
            
      end case;
    end loop;  
  end process;
  
  
  -------------------------
  -- Level 3 comparators
  -------------------------
  
  -- Here we have only one comparator, plus we dont need
  -- the priority on the output...  
  
  -- Validity of level 3 is also the output validity
  l3_valid  <= '0' when l2_valid(1 downto 0) = "00" 
                   else
                '1';
  output_valid <= true when l3_valid = '1' else false;
  
  -- Priority comparator of level 3
  l3_winner  <= LOWER_TREE when l2_valid(1 downto 0) = "01" else
                UPPER_TREE when l2_valid(1 downto 0) = "10" else
                LOWER_TREE
                    when (l2_valid(1 downto 0) = "11" and
                      unsigned(l2_prio(0)) > unsigned(l2_prio(1))) 
                    else 
                UPPER_TREE;
   
         
   -------------------------
   -- Output index decoder
   -------------------------
   -- Just find out the winning buffer index from decisions in the tree
   
   -- Note that modulo is used only for purpose of getting rid of
   -- compiler warnings. If lower amount of buffers is on input 
   -- (TXT_BUFFER_COUNT), then higher indices of input priorities and
   -- valid sinals are set to 0. This leads to the case that "buf_index" 
   -- will NEVER be assigned value higher than its available
   -- range.
   
   out_index_proc:process(l3_winner, l2_winner, l1_winner)
   begin
      if (l3_winner = LOWER_TREE) then
          if (l2_winner(0) = LOWER_TREE) then
              if (l1_winner(0) = LOWER_TREE) then
                output_index <= 0;
              else
                output_index <= 1;
              end if;
          else
              if (l1_winner(1) = LOWER_TREE)then
                output_index <= 2 mod buf_count;
              else
                output_index <= 3 mod buf_count;
              end if;
          end if;      
      else
          if (l2_winner(1) = LOWER_TREE) then
              if (l1_winner(2) = LOWER_TREE) then
                output_index <= 4 mod buf_count;
              else
                output_index <= 5 mod buf_count;
              end if;
          else
              if (l1_winner(3) = LOWER_TREE)then
                output_index <= 6 mod buf_count;
              else
                output_index <= 7 mod buf_count;
              end if;
          end if;   
      end if;
   end process;
   
   
                 
  
end architecture;