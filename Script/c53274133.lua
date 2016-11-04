--Iron Chain Magnetic Ball
function c53274133.initial_effect(c)
	--lp damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c53274133.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot select battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(c53274133.atlimit)
	c:RegisterEffect(e2)
end
function c53274133.atlimit(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsSetCard(0x25) 
end
function c53274133.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x25)
end
function c53274133.indcon(e)
	return Duel.IsExistingMatchingCard(c53274133.indfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c53274133.filter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE) and c:IsSetCard(0x25)
		and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
end