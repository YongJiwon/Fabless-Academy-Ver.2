`timescale 1ns / 1ps

module data_rom (
    input  logic [31:0] data_addr, // 입력: CPU(Datapath)에서 나오는 데이터 주소 (Ex: LW 명령어의 주소)
    output logic [31:0] data_rd    // 출력: CPU로 보낼 32비트 읽기 데이터 (Read Data)
);

    // 32비트 크기의 메모리 방 16개(RAM 구조 배열)를 선언합니다.
    logic [31:0] data_mem[0:15];

    // 시뮬레이션 시작 시점에 데이터 방에 검증용 수치들을 주입합니다.
    initial begin
        // [Addr 인덱스: 0] 일반 양수 데이터 테스트
        data_mem[0]  = 32'h0000_000A; // 십진수 10
        
        // [Addr 인덱스: 1] 일반 양수 데이터 테스트 2
        data_mem[1]  = 32'h0000_0064; // 십진수 100

        // [Addr 인덱스: 2] 부호 확장(Sign Extension) 검증용 음수 데이터 (-1)
        // LW로 읽었을 때 32비트 전체가 1로 채워지는지 확인하는 용도입니다.
        data_mem[2]  = 32'hffff_ffff; // 십진수 -1

        // [Addr 인덱스: 3] 음수 데이터 2 (-100)
        data_mem[3]  = 32'hffff_ff9c; // 십진수 -100

        // [Addr 인덱스: 4] 비트 마스킹 및 논리 연산(AND/OR/XOR) 검증용 데이터
        data_mem[4]  = 32'haaaa_aaaa; 
        
        // [Addr 인덱스: 5] 비트 마스킹 및 논리 연산 검증용 데이터 2
        data_mem[5]  = 32'h5555_5555;

        // [Addr 인덱스: 6] 최상위 비트(MSB)만 1인 극단적 경계값 데이터 (음수 최댓값)
        data_mem[6]  = 32'h8000_0000;

        // 나머지 공간(인덱스 7~15)은 0으로 안전하게 패딩합니다.
        data_mem[7]  = 32'h0000_0000;
        data_mem[8]  = 32'h0000_0000;
        data_mem[9]  = 32'h0000_0000;
        data_mem[10] = 32'h0000_0000;
        data_mem[11] = 32'h0000_0000;
        data_mem[12] = 32'h0000_0000;
        data_mem[13] = 32'h0000_0000;
        data_mem[14] = 32'h0000_0000;
        data_mem[15] = 32'h0000_0000;
    end

    // 바이트 주소를 4로 나누어(하위 2비트 절삭) 32비트 워드 인덱스로 매핑하되,
    // 배열 크기가 16개이므로 주소의 [5:2] 비트(총 4비트 범위, 0~15)만 사용하여 인덱싱합니다.
    // 조합 회로이므로 주소가 들어오는 즉시 지연 없이 데이터를 방출합니다.
    assign data_rd = data_mem[data_addr[5:2]];

endmodule