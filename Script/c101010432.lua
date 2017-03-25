--created & coded by Lyris
--「S・VINE」アストラル・ドラゴン
function c101010432.initial_effect(c)
	c:EnableReviveLimit()
	if not c101010432.global_check then
		c101010432.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010432.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010432.spatial=true
c101010432.dimensional_number_o=8
c101010432.dimensional_number=c101010432.dimensional_number_o
c101010432.material=aux.TRUE
function c101010432.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,500)
	Duel.CreateToken(1-tp,500)
end
