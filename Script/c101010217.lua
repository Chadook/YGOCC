--created & coded by Lyris
--S・VINEの零嬢天使ラグナクライッシャ
function c101010217.initial_effect(c)
	c:EnableReviveLimit()
	local ae3=Effect.CreateEffect(c)
	ae3:SetCategory(CATEGORY_REMOVE)
	ae3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ae3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	ae3:SetCode(EVENT_TO_GRAVE)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetCondition(c101010217.condition)
	ae3:SetTarget(c101010217.target)
	ae3:SetOperation(c101010217.operation)
	c:RegisterEffect(ae3)
	if not c101010217.global_check then
		c101010217.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010217.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010217.spatial=true
c101010217.dimensional_number_o=4
c101010217.dimensional_number=c101010217.dimensional_number_o
function c101010217.material(mc)
	return mc:IsAttribute(ATTRIBUTE_WATER) and mc:IsSetCard(0x785e)
end
function c101010217.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,500)
	Duel.CreateToken(1-tp,500)
end
function c101010217.cfilter(c)
	return c:IsLevelAbove(1) and c:IsSetCard(0x785e)
end
function c101010217.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:FilterCount(Card.IsType,nil,TYPE_MONSTER)==1 and c101010217.cfilter(tc)
end
function c101010217.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785e) and c:IsAbleToRemove()
end
function c101010217.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010217.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c101010217.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101010217.filter2,tp,LOCATION_DECK,0,1,eg:GetFirst():GetLevel(),nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
