--created & coded by Lyris
--Pegasus of Stellar Vine
function c101010185.initial_effect(c)
--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83274244,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c101010185.ntcon)
	e1:SetOperation(c101010185.nsop)
	c:RegisterEffect(e1)
end
function c101010185.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785e) and c:IsAbleToGraveAsCost()
end
function c101010185.ntcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010185.cfilter,tp,LOCATION_REMOVED,0,1,nil)
end
function c101010185.nsop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010185,0))
	local g=Duel.SelectMatchingCard(tp,c101010185.cfilter,tp,LOCATION_REMOVED,0,1,3,nil)
	local ct=Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(1400)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(300*ct)
	c:RegisterEffect(e2)
end
