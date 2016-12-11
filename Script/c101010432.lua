--created & coded by Lyris
--Astral Dragon of Stellar Vine
function c101010432.initial_effect(c)
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
--Spatial Formula filter(s)
c101010432.material=function(mc) return mc:IsSetCard(0x785a) end
function c101010432.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,500)
	Duel.CreateToken(1-tp,500)
end

