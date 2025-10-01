'''
1. 정규분포(Normal Distribution)란?
	ㄴ 확률 분포(Probability Distribution)의 한 종류
	ㄴ 어떤 현상이나 데이터가 평균값(중심)을 기준으로 대칭적으로 분포하는 형태를 말함
	ㄴ 그래프는 종(bell) 모양 곡선
	ㄴ ex) 키, 시험 점수, 자연 현상에서 발생하는 오차 등은 보통 정규분포 형태를 따름

2. 표준편차(Standard Deviation)란?
	ㄴ 데이터가 평균으로부터 얼마나 흩어져 있는지를 나타내는 값
	ㄴ ex) 평균이 170cm인 사람들의 키가 있을 때
			표준편차가 3cm라면 대부분 사람들의 키가 167cm ~ 173cm에 몰려 있음

3. 게임에서 응용 예제
	3-1. 대미지 계산
		ㄴ 보통 RPG 게임에서 공격력이 100일 때 정규분포(평균 = 100, 표준편차 = 5)를 쓰면
			대부분 95 ~ 105 근처에서 나오고, 가끔 90 또는 110 같은 극단도 나올 수 있음
	
	3-2. NPC 능력치 분포
		ㄴ 몬스터의 체력을 생성할 때 정규분포(평균 = 100, 표준편차 = 10)를 쓰면
			대부분 비슷한 체력을 가지지만, 강한 개체나 약한 개체도 자연스럽게 나옴
	
	3-3. 아이템 드랍이나 가챠 확률
		ㄴ 정규분포를 쓰면, 대부분은 중간 등급 아이템이 나오고,
			아주 드물게 희귀 아이템이 나오게 조정할 수 있음
'''

extends Node
'''
- Autoload에 등록된 전역에서 사용하는 난수 유틸리티
- 지정한 범위 내에서 정규분포 난수를 반환
'''

'''
- RandomNumberGenerator는 Godot 엔진이 제공하는 난수 전용 클래스
- RandomNumberGenerator 인스턴스를 만들어 재사용
'''
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	'''
	- 매 호출마다 새로 시드를 초기화하면 성능 저하 및 시퀀스 품질 문제가
		발생 가능하기 때문에 앱 시작 시 한 번만 시드를 초기화
	'''
	rng.randomize()

'''
- get_ndn		: Get Normal Distribution Number의 약자로 정규분포 난수 반환 함수
- min_num		: 허용하는 최솟값 (포함)
- max_num		: 허용하는 최댓값 (포함)
- deviation		: 표준편차로 값이 작을수록 평균 근처에 몰림
- max_attempts	: 재추출을 시도하는 최대 횟수로 안전장치 역할
'''
func get_ndn(min_num: float, max_num: float, \
				deviation: float, max_attempts: int = 1000) -> float:
	# 범위의 중앙을 평균(mean)으로 사용
	var mean: float = (min_num + max_num) / 2.0
	# 추출 값을 담을 변수
	var value: float = 0.0
	
	# 재추출 루프로 범위 안의 값을 얻을 때까지 반복
	for i in range(max_attempts):
		value = rng.randfn(mean, deviation)
		if value >= min_num and value <= max_num:
			break
	
	'''
	- 만약 max_attempts 만큼 시도했는데도 범위 밖이면 value는 마지막 시도 값이므로
		clamp로 안전하게 보정하여 반환
	- 무한 루프 가능성을 방지하면서도 대부분의 경우 재추출된 값이 반환됨
	'''
	return clamp(value, min_num, max_num)
