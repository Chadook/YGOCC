--Stymphal Turbulance
function c11262.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c11262.condition)
	e1:SetOperation(c11262.operation)
	e1:SetCountLimit(1,11262)
	c:RegisterEffect(e1)
end
function c11262.tgfilter(c)
	return c:IsSetCard(0x2BF2) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c11262.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2BF2) and c:GetCode()~=11262
end
function c11262.condition(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11262.tgfilter,tp,LOCATION_DECK,0,1,c) and
		Duel.IsExistingMatchingCard(c11262.filter,tp,LOCATION_MZONE,0,1,c)
end
function c11262.operation(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11262.tgfilter,tp,LOCATION_DECK,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c11262.synlimit)
	c:RegisterEffect(e1,true)
end
function c11262.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x2BF2)
end

